Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaHVHrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:47:33 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:47656
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754392AbaHVHrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:47:31 -0400
Date: Fri, 22 Aug 2014 15:47:12 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Stefan Agner <stefan@agner.ch>, <peter.chen@freescale.com>,
        <s.hauer@pengutronix.de>, <kernel@pengutronix.de>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <jingchang.lu@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v2 7/7] ARM: dts: vf610-twr: Add USB support
Message-ID: <20140822074711.GC2540@dragon>
References: <cover.1408391385.git.stefan@agner.ch>
 <07491836b9c23a82b7a33972a5c71f2676ceaf71.1408391385.git.stefan@agner.ch>
 <53F26105.9000907@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53F26105.9000907@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(377454003)(199003)(479174003)(24454002)(51704005)(189002)(44976005)(4396001)(6806004)(85306004)(47776003)(74662001)(20776003)(95666004)(83322001)(23726002)(31966008)(50466002)(79102001)(33716001)(92726001)(80022001)(92566001)(90102001)(74502001)(46102001)(99396002)(86362001)(97736001)(64706001)(97756001)(83072002)(68736004)(77982001)(87936001)(81342001)(85852003)(84676001)(104016003)(33656002)(54356999)(76482001)(83506001)(81156004)(26826002)(21056001)(105606002)(76176999)(81542001)(46406003)(50986999)(69596002)(102836001)(107046002)(110136001)(106466001)(57986006)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0782;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0311124FA9
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 12:24:37AM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 08/19/2014 12:07 AM, Stefan Agner wrote:
> 
> >Add USB support for Freescale Vybrid tower. The USB hosts over-current
> >protection signal is not connected is not connected to the PHY's over-
> 
>    Yes, we all understood that it's not connected, no need to repeat. ;-)

I will fix it up when applying.

Shawn
