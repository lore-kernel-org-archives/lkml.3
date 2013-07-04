Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3GDOSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:18:20 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:54378
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708Ab3GDOST convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:18:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275dh17598djz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Stehle Vincent-B46079 <B46079@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: RE: Mainline crashes in wm8962_probe() on i.MX6
Thread-Topic: Mainline crashes in wm8962_probe() on i.MX6
Thread-Index: Ac54o2gbdlNidAQESmG0hRwqYXenawAGed8AAADuD5A=
Date: Thu, 4 Jul 2013 14:18:11 +0000
Message-ID: <F7C43F8B2814514CA05F3436BC68046EF3AD16@039-SN2MPN1-011.039d.mgd.msft.net>
References: <F7C43F8B2814514CA05F3436BC68046EF3A272@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130704134930.GC11046@S2101-09.ap.freescale.net>
In-Reply-To: <20130704134930.GC11046@S2101-09.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.137.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Shawn Guo [mailto:shawn.guo@linaro.org]
(..)
> Yeah, I just ran into it with linux-next and reported it there [1].  I
> will send a formal patch for it soon.
> [1] http://thread.gmane.org/gmane.linux.alsa.devel/109844

Thank you for your patch; I confirm it repairs mainline imx_v6_v7_defconfig on i.MX6 sabre sd.

Best regards,

V.


