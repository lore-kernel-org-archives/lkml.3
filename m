Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3CUD40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:56:26 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:54939
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974Ab3CUD4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:56:25 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz2dh2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1155h)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Chris Ball <cjb@laptop.org>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Miao, Steven" <Steven.Miao@analog.com>
Date: Wed, 20 Mar 2013 23:56:08 -0400
Subject: RE: Missing WIDE_BUS_[48] (was: Re: mmc: bfin_sdh: Add support for
 new RSI controller in bf60x)
Thread-Topic: Missing WIDE_BUS_[48] (was: Re: mmc: bfin_sdh: Add support for
 new RSI controller in bf60x)
Thread-Index: Ac4lTsEUwPf6ticWSlm9ALsc7B4FRwAlMMBw
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D173FF57E1AE@NWD2CMBX1.ad.analog.com>
References: <CAMuHMdVPNdrvOSDWNhKqOSuLJL39dMuDmDAjuKerFGnZ5WvkOQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVPNdrvOSDWNhKqOSuLJL39dMuDmDAjuKerFGnZ5WvkOQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2L3uPFR004154

Hi Geert,

>-----Original Message-----
>From: geert.uytterhoeven@gmail.com [mailto:geert.uytterhoeven@gmail.com] On
>Behalf Of Geert Uytterhoeven
>Sent: Wednesday, March 20, 2013 5:39 PM
>To: Zhang, Sonic; Chris Ball
>Cc: uclinux-dist-devel@blackfin.uclinux.org; linux-kernel@vger.kernel.org
>Subject: Missing WIDE_BUS_[48] (was: Re: mmc: bfin_sdh: Add support for new
>RSI controller in bf60x)
>
>On Wed, Oct 10, 2012 at 4:28 AM, Linux Kernel Mailing List <linux-
>kernel@vger.kernel.org> wrote:
>> Gitweb:
>http://git.kernel.org/linus/;a=commit;h=4ffdcf0469f1e7e47476ee410e8dfbc6aba61b
>65
>> Commit:     4ffdcf0469f1e7e47476ee410e8dfbc6aba61b65
>> Parent:     0462566b1e3129b2920b63b62a653b70a1bc36fa
>> Author:     Sonic Zhang <sonic.zhang@analog.com>
>> AuthorDate: Wed Aug 8 00:13:32 2012 -0400
>> Committer:  Chris Ball <cjb@laptop.org>
>> CommitDate: Tue Sep 4 13:58:18 2012 -0400
>>
>>     mmc: bfin_sdh: Add support for new RSI controller in bf60x
>
>> +               clk_ctl |= WIDE_BUS_4;
>
>Any plans to introduce this "WIDE_BUS_4", and the corresponding
>"WIDE_BUS_8"
>symbols in mainline?
>

Bob forgot to push the patch against the head file to the blackfin arch tree in last merge window.
It will be done in next merge window.

Thanks

Sonic


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
