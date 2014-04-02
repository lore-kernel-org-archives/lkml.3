Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbaDBJP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:15:27 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:57773 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758293AbaDBJPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:15:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Wed, 2 Apr 2014 17:15:01 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <viresh.linux@gmail.com>, <shiraz.hashim@st.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <ijc+devicetree@hellion.org.uk>, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] ARM: dts: stmpe-ts: fix wrong bindings
Message-ID: <20140402091459.GB10283@dragon>
References: <1386620111-1413-1-git-send-email-stefan@agner.ch>
 <201312092132.29575.marex@denx.de>
 <2acd964e18e59b35996d042a3dd6e99b@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2acd964e18e59b35996d042a3dd6e99b@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 09:48:58AM +0200, Stefan Agner wrote:
> Am 2013-12-09 21:32, schrieb Marek Vasut:
> > On Monday, December 09, 2013 at 09:15:11 PM, Stefan Agner wrote:
> >> Fix bindings for STMPE touchscreen device to match the documented
> >> bindings and the actual bindings used by the driver.
> >>
> >> Signed-off-by: Stefan Agner <stefan@agner.ch>
> >> ---
> >> I don't have any of these hardware, but the error is obvious. The device
> >> probably works anyway since the device/driver will use default values.
> > 
> > Full agreement here.
> > 
> > Reviewed-by: Marek Vasut <marex@denx.de>
> > 
> > btw. I plan to rework the STMPE TS as it doesn't work nicely on my device at 
> > all. I am seriously lacking time, but I will try! ;-)
> > 
> > Best regards,
> > Marek Vasut
> 
> Hi Shawn,
> 
> Just noticed that I forgot to add you when sending this patch. I guess
> this should go through your tree...

You should probably resend the patch against the latest kernel, and with
imx change in a separate patch.

Shawn

