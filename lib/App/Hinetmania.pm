package App::Hinetmania;

use warnings;
use strict;
use utf8;
use AnyEvent;
use AnyEvent::Twitter;
use Encode;
use Net::WeatherNews::QuakeWarning;

=head1 NAME

App::Hinetmania - The great new App::Hinetmania!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use App::Hinetmania;

    my $foo = App::Hinetmania->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new {
    my $class = shift;
    my $self = bless { @_, qid => 0 }, $class;
    $self->dataSet;
    return $self;
}

=head2 dataSet

=cut

sub dataSet {
    my $self     = shift;
    my %location = (
        000 => "不明",
        100 => "石狩支庁北部",
        101 => "石狩支庁中部",
        102 => "石狩支庁南部",
        105 => "渡島支庁北部",
        106 => "渡島支庁東部",
        107 => "渡島支庁西部",
        110 => "檜山支庁",
        115 => "後志支庁北部",
        116 => "後志支庁東部",
        117 => "後志支庁西部",
        120 => "空知支庁北部",
        121 => "空知支庁中部",
        122 => "空知支庁南部",
        125 => "上川支庁北部",
        126 => "上川支庁中部",
        127 => "上川支庁南部",
        130 => "留萌支庁中北部",
        131 => "留萌支庁南部",
        135 => "宗谷支庁北部",
        136 => "宗谷支庁南部",
        140 => "網走支庁網走地方",
        141 => "網走支庁北見地方",
        142 => "網走支庁紋別地方",
        145 => "胆振支庁西部",
        146 => "胆振支庁中東部",
        150 => "日高支庁西部",
        151 => "日高支庁中部",
        152 => "日高支庁東部",
        155 => "十勝支庁北部",
        156 => "十勝支庁中部",
        157 => "十勝支庁南部",
        160 => "釧路支庁北部",
        161 => "釧路支庁中南部",
        165 => "根室支庁北部",
        166 => "根室支庁中部",
        167 => "根室支庁南部",
        180 => "北海道南西沖",
        181 => "北海道西方沖",
        182 => "石狩湾",
        183 => "北海道北西沖",
        184 => "宗谷海峡",
        186 => "国後島付近",
        187 => "択捉島付近",
        188 => "北海道東方沖",
        189 => "根室半島南東沖",
        190 => "釧路沖",
        191 => "十勝沖",
        192 => "浦河沖",
        193 => "苫小牧沖",
        194 => "内浦湾",
        195 => "宗谷東方沖",
        196 => "網走沖",
        197 => "択捉島南東沖",
        200 => "青森県津軽北部",
        201 => "青森県津軽南部",
        202 => "青森県三八上北地方",
        203 => "青森県下北地方",
        210 => "岩手県沿岸北部",
        211 => "岩手県沿岸南部",
        212 => "岩手県内陸北部",
        213 => "岩手県内陸南部",
        220 => "宮城県北部",
        221 => "宮城県南部",
        222 => "宮城県中部",
        230 => "秋田県沿岸北部",
        231 => "秋田県沿岸南部",
        232 => "秋田県内陸北部",
        233 => "秋田県内陸南部",
        240 => "山形県庄内地方",
        241 => "山形県最上地方",
        242 => "山形県村山地方",
        243 => "山形県置賜地方",
        250 => "福島県中通り",
        251 => "福島県浜通り",
        252 => "福島県会津",
        280 => "津軽海峡",
        281 => "山形県沖",
        282 => "秋田県沖",
        283 => "青森県西方沖",
        284 => "陸奥湾",
        285 => "青森県東方沖",
        286 => "岩手県沖",
        287 => "宮城県沖",
        288 => "三陸沖",
        289 => "福島県沖",
        300 => "茨城県北部",
        301 => "茨城県南部",
        309 => "千葉県南東沖",
        310 => "栃木県北部",
        311 => "栃木県南部",
        320 => "群馬県北部",
        321 => "群馬県南部",
        330 => "埼玉県北部",
        331 => "埼玉県南部",
        332 => "埼玉県秩父地方",
        340 => "千葉県北東部",
        341 => "千葉県北西部",
        342 => "千葉県南部",
        349 => "房総半島南方沖",
        350 => "東京都２３区",
        351 => "東京都多摩東部",
        352 => "東京都多摩西部",
        360 => "神奈川県東部",
        361 => "神奈川県西部",
        370 => "新潟県上越地方",
        371 => "新潟県中越地方",
        372 => "新潟県下越地方",
        378 => "新潟県下越沖",
        379 => "新潟県上中越沖",
        380 => "富山県東部",
        381 => "富山県西部",
        390 => "石川県能登地方",
        391 => "石川県加賀地方",
        400 => "福井県嶺北",
        401 => "福井県嶺南",
        411 => "山梨県中・西部",
        412 => "山梨県東部・富士五湖",
        420 => "長野県北部",
        421 => "長野県中部",
        422 => "長野県南部",
        430 => "岐阜県飛騨地方",
        431 => "岐阜県美濃東部",
        432 => "岐阜県美濃中西部",
        440 => "静岡県伊豆地方",
        441 => "静岡県東部",
        442 => "静岡県中部",
        443 => "静岡県西部",
        450 => "愛知県東部",
        451 => "愛知県西部",
        460 => "三重県北部",
        461 => "三重県中部",
        462 => "三重県南部",
        469 => "三重県南東沖",
        471 => "茨城県沖",
        472 => "関東東方沖",
        473 => "千葉県東方沖",
        475 => "八丈島東方沖",
        476 => "八丈島近海",
        477 => "東京湾",
        478 => "相模湾",
        480 => "伊豆大島近海",
        481 => "伊豆半島東方沖",
        482 => "三宅島近海",
        483 => "新島・神津島近海",
        485 => "駿河湾",
        486 => "駿河湾南方沖",
        487 => "遠州灘",
        489 => "三河湾",
        490 => "伊勢湾",
        492 => "若狭湾",
        493 => "福井県沖",
        494 => "石川県西方沖",
        495 => "能登半島沖",
        497 => "富山湾",
        498 => "佐渡付近",
        499 => "東海道南方沖",
        500 => "滋賀県北部",
        501 => "滋賀県南部",
        510 => "京都府北部",
        511 => "京都府南部",
        520 => "大阪府北部",
        521 => "大阪府南部",
        530 => "兵庫県北部",
        531 => "兵庫県南東部",
        532 => "兵庫県南西部",
        540 => "奈良県",
        550 => "和歌山県北部",
        551 => "和歌山県南部",
        560 => "鳥取県東部",
        562 => "鳥取県中部",
        563 => "鳥取県西部",
        570 => "島根県東部",
        571 => "島根県西部",
        580 => "岡山県北部",
        581 => "岡山県南部",
        590 => "広島県北部",
        591 => "広島県南東部",
        592 => "広島県南西部",
        600 => "徳島県北部",
        601 => "徳島県南部",
        610 => "香川県東部",
        611 => "香川県西部",
        620 => "愛媛県東予",
        621 => "愛媛県中予",
        622 => "愛媛県南予",
        630 => "高知県東部",
        631 => "高知県中部",
        632 => "高知県西部",
        673 => "土佐湾",
        674 => "紀伊水道",
        675 => "大阪湾",
        676 => "播磨灘",
        677 => "瀬戸内海中部",
        678 => "安芸灘",
        679 => "周防灘",
        680 => "伊予灘",
        681 => "豊後水道",
        682 => "山口県北西沖",
        683 => "島根県沖",
        684 => "鳥取県沖",
        685 => "隠岐島近海",
        686 => "兵庫県北方沖",
        687 => "京都府沖",
        688 => "淡路島付近",
        689 => "和歌山県南方沖",
        700 => "山口県北部",
        701 => "山口県東部",
        702 => "山口県西部",
        710 => "福岡県福岡地方",
        711 => "福岡県北九州地方",
        712 => "福岡県筑豊地方",
        713 => "福岡県筑後地方",
        720 => "佐賀県北部",
        721 => "佐賀県南部",
        730 => "長崎県北部",
        731 => "長崎県南西部",
        732 => "長崎県島原半島",
        740 => "熊本県阿蘇地方",
        741 => "熊本県熊本地方",
        742 => "熊本県球磨地方",
        743 => "熊本県天草・芦北地方",
        750 => "大分県北部",
        751 => "大分県中部",
        752 => "大分県南部",
        753 => "大分県西部",
        760 => "宮崎県北部平野部",
        761 => "宮崎県北部山沿い",
        762 => "宮崎県南部平野部",
        763 => "宮崎県南部山沿い",
        770 => "鹿児島県薩摩地方",
        771 => "鹿児島県大隅地方",
        783 => "五島列島近海",
        784 => "天草灘",
        785 => "有明海",
        786 => "橘湾",
        787 => "鹿児島湾",
        790 => "種子島近海",
        791 => "日向灘",
        793 => "奄美大島近海",
        795 => "壱岐・対馬近海",
        796 => "福岡県北西沖",
        797 => "薩摩半島西方沖",
        798 => "トカラ列島近海",
        799 => "奄美大島北西沖",
        820 => "大隅半島東方沖",
        821 => "九州地方南東沖",
        822 => "種子島南東沖",
        823 => "奄美大島北東沖",
        850 => "沖縄本島近海",
        851 => "南大東島近海",
        852 => "沖縄本島南方沖",
        853 => "宮古島近海",
        854 => "石垣島近海",
        855 => "石垣島南方沖",
        856 => "西表島付近",
        857 => "与那国島近海",
        858 => "沖縄本島北西沖",
        859 => "宮古島北西沖",
        860 => "石垣島北西沖",
        900 => "台湾付近",
        901 => "東シナ海",
        902 => "四国沖",
        903 => "鳥島近海",
        904 => "鳥島東方沖",
        905 => "オホーツク海南部",
        906 => "サハリン西方沖",
        907 => "日本海北部",
        908 => "日本海中部",
        909 => "日本海西部",
        911 => "父島近海",
        912 => "千島列島",
        913 => "千島列島南東沖",
        914 => "北海道南東沖",
        915 => "東北地方東方沖",
        916 => "小笠原諸島西方沖",
        917 => "硫黄島近海",
        918 => "小笠原諸島東方沖",
        919 => "南海道南方沖",
        920 => "薩南諸島東方沖",
        921 => "本州南方沖",
        922 => "サハリン南部付近",
        930 => "北西太平洋",
        932 => "マリアナ諸島",
        933 => "黄海",
        934 => "朝鮮半島南部",
        935 => "朝鮮半島北部",
        936 => "中国東北部",
        937 => "ウラジオストク付近",
        938 => "シベリア南部",
        939 => "サハリン近海",
        940 => "アリューシャン列島",
        941 => "カムチャツカ半島付近",
        942 => "北米西部",
        943 => "北米中部",
        944 => "北米東部",
        945 => "中米",
        946 => "南米西部",
        947 => "南米中部",
        948 => "南米東部",
        949 => "北東太平洋",
        950 => "南太平洋",
        951 => "インドシナ半島付近",
        952 => "フィリピン付近",
        953 => "インドネシア付近",
        954 => "グアム付近",
        955 => "ニューギニア付近",
        956 => "ニュージーランド付近",
        957 => "オーストラリア付近",
        958 => "シベリア付近",
        959 => "ロシア西部",
        960 => "ロシア中部",
        961 => "ロシア東部",
        962 => "中央アジア",
        963 => "中国西部",
        964 => "中国中部",
        965 => "中国東部",
        966 => "インド付近",
        967 => "インド洋",
        968 => "中東",
        969 => "ヨーロッパ西部",
        970 => "ヨーロッパ中部",
        971 => "ヨーロッパ東部",
        972 => "地中海",
        973 => "アフリカ西部",
        974 => "アフリカ中部",
        975 => "アフリカ東部",
        976 => "北大西洋",
        977 => "南大西洋",
        978 => "北極付近",
        979 => "南極付近",
    );
    $self->{location} = \%location;
    return $self;
}

=head2 run

=cut

sub run {
    my $self = shift;
    $self->{condvar} = AnyEvent->condvar;
    $self->{twitter} = AnyEvent::Twitter->new(
        consumer_key        => $self->{consumer_key},
        consumer_secret     => $self->{consumer_secret},
        access_token        => $self->{access_token},
        access_token_secret => $self->{access_token_secret},
    );
    $self->{wmi} = Net::WeatherNews::QuakeWarning->new(
        email    => $self->{wmi_email},
        password => $self->{wmi_passwd},
        on_warning =>
          sub { my $text = shift; print $text; $self->printout($text) },
    );
    $self->{wmi}->connect;

    $self->{condvar}->recv;
}

=head2 printout 

=cut

sub printout {
    my $self = shift;
    my $text = shift;

    my $string = $self->filter($text);
    $self->{twitter}->request(
        api    => 'statuses/update',
        method => 'POST',
        params => { status => $string },
        sub { print "execute\n" }
    ) if ($string);
}

=head2 filter

=cut

sub filter {
    my $self = shift;
    my $text = shift;
    my $ret;

    my ( $year, $month, $date, $hour, $min, $sec ) = ( $1, $2, $3, $4, $5, $6 )
      if ( $text =~ /^(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/m );
    my ( $area, $lat, $long, $depth, $magnitude, $scale ) =
      ( $self->{location}->{$1}, $2 / 10, $3 / 10, $4, $5 / 10, $6 )
      if ( $text =~
        /^(\d{3}) N(\d{3}) E(\d{4}) (\d{3}) (\d{2}) ([0-9\-\+\/]{2}) RK/m );
    my ( $id, $type, $num ) = ( $1, $2, $3 )
      if ( $text =~ /ND(\d{14}) ([A-Z]+)(\d+)/ );

    if ( $year && $area && ( $self->{qid} ne $id ) ) {
        $scale = "不明" unless ( $scale =~ /\d+/ );
        my $tmp =
            "[速報] 20%02d/%02d/%02d %2d:%02dに"
          . "M%.1f 予想最大震度%sの地震が%sで発生した模様です "
          . "http://maps.google.co.jp"
          . "/maps?f=q&hl=ja&t=k&om=0&z=7&q=%.1f%%20%.1f\n";

        $ret = sprintf $tmp,
          $year, $month, $date, $hour, $min, $magnitude, $scale, $area, $lat,
          $long;
        $self->{qid} = $id;
    }
    return $ret;
}

=head1 AUTHOR

Keiichi Daiba, C<< <daiba at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-hinetmania at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Hinetmania>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Hinetmania


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Hinetmania>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Hinetmania>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Hinetmania>

=item * Search CPAN

L<http://search.cpan.org/dist/App-Hinetmania/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Keiichi Daiba.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of App::Hinetmania
