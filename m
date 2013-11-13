Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3KMBv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:51:56 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:46162
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754491Ab3KMBvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:51:49 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh109h2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216hbe9i1155h)
From: Shaohui Xie <Shaohui.Xie@freescale.com>
To: Scott Wood <scottwood@freescale.com>,
        "shh.xie@gmail.com" <shh.xie@gmail.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Madalin-Cristian Bucur <madalin.bucur@freescale.com>
Subject: RE: [PATCH 1/4] phylib: Add Clause 45 read/write functions
Thread-Topic: [PATCH 1/4] phylib: Add Clause 45 read/write functions
Thread-Index: AQHO3tiLs19l/z/zlEG78+nbLumxJZoiJtiAgABAxlA=
Date: Wed, 13 Nov 2013 01:51:45 +0000
Message-ID: <ED492CCEAF882048BC2237DE806547C91512489F@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1384167864-2457-1-git-send-email-shh.xie@gmail.com>
 <1384293487.1403.67.camel@snotra.buserror.net>
In-Reply-To: <1384293487.1403.67.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.53]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAD1q1Yo029730

> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Wednesday, November 13, 2013 5:58 AM
> To: shh.xie@gmail.com
> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Kanetkar
> Shruti-B44454; Xie Shaohui-B21989; Bucur Madalin-Cristian-B32716
> Subject: Re: [PATCH 1/4] phylib: Add Clause 45 read/write functions
> 
> On Mon, 2013-11-11 at 19:04 +0800, shh.xie@gmail.com wrote:
> > From: Andy Fleming
> >
> > You need an extra parameter to read or write Clause 45 PHYs, so we
> > need a different API with the extra parameter.
> >
> > Signed-off-by: Andy Fleming
> > Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
> 
> Why did you remove Andy's e-mail address?  Even though it's no longer valid, it
> helps identify which specific person you're talking about.
> 
[S.H] Andy's e-mail address is not valid and git-send-mail will fail, I have to remove it to make git work.


Best Regards, 
Shaohui Xie
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
