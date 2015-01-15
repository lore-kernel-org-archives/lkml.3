Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbbAOHuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:50:51 -0500
Received: from mx1.epson.co.jp ([203.179.21.130]:60704 "EHLO mx1.epson.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbbAOHuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:50:50 -0500
From: Nakashima Akihiro <Nakashima.Akihiro@exc.epson.co.jp>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ueda Motoki <Ueda.Motoki@exc.epson.co.jp>,
        "Otsu Takahiro" <Otsu.Takahiro@exc.epson.co.jp>,
        Tomono Mitsunori <Tomono.Mitsunori@exc.epson.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: PROBLEM: [3.4] neigh_destroy() crashes on unplug netdev.
Thread-Topic: PROBLEM: [3.4] neigh_destroy() crashes on unplug netdev.
Thread-Index: AdAwht3nzPqnF/rnSHqgeN93j8w5nv//fhOA//9f8qA=
Date: Thu, 15 Jan 2015 07:50:41 +0000
Message-ID: <E694983F62A0954788A62E997021A9C3109443@JPEX011.apo.epson.net>
References: <E694983F62A0954788A62E997021A9C31093E1@JPEX011.apo.epson.net>
 <1421305399.11734.40.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1421305399.11734.40.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.190.203]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-TM-AS-Product-Ver: IMSS-7.0.0.8250-6.8.0.1017-21252.003
X-TM-AS-User-Approved-Sender: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0F7ow79012285

Dear Eric:

3.6 or later kernels (including recent mainline) do not have this problem.
3.4.105 is based on an old kernel, but it is a latest kernel of 3.4 LTS branch.
I think it is better to backport 20 patches to LTS branch.
But if you do not have such support policy, I will apply these patches to my 3.4 kernel only.

Thanks

-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: Thursday, January 15, 2015 4:03 PM
To: Nakashima Akihiro
Cc: davem@davemloft.net; netdev@vger.kernel.org; Ueda Motoki; Otsu Takahiro; Tomono Mitsunori; linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: [3.4] neigh_destroy() crashes on unplug netdev.

On Thu, 2015-01-15 at 05:57 +0000, Nakashima Akihiro wrote:
> Dear David and networking developers:
> 
> I got kernel panic on 3.4.105 kernel.
> Please see a report below.

Please try a recent kernel.

We are not going to debug such an old one, given there are chances we already fixed the problem ages ago.

Thanks



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
