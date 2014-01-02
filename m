Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853AbaABCQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:16:56 -0500
Received: from [65.55.88.15] ([65.55.88.15]:4289 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750732AbaABCQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:16:54 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 2 Jan 2014 10:16:03 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
CC: Anson Huang <b20788@freescale.com>, <eduardo.valentin@ti.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] thermal: imx: correct suspend/resume flow
Message-ID: <20140102021601.GA15104@S2101-09.ap.freescale.net>
References: <1387896204-31754-1-git-send-email-b20788@freescale.com>
 <1388628111.3739.68.camel@rzhang1-mobl4>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1388628111.3739.68.camel@rzhang1-mobl4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 10:01:51AM +0800, Zhang Rui wrote:
> On Tue, 2013-12-24 at 09:43 -0500, Anson Huang wrote:
> > Fixes regression introduced by:
> > 
> > commit 37713a1e8e4c1a1067ad4c99296f78d3c82ed9c4
> > Author: Philipp Zabel <p.zabel@pengutronix.de>
> > Date:   Thu Aug 1 18:33:12 2013 +0200
> > 
> >     thermal: imx: implement thermal alarm interrupt handling
> > 
> > The commit 37713a1e8e4 makes imx thermal sensor always powered up as alarm
> > function is enabled, but the suspend callback of imx thermal returns
> > success only if thermal sensor is powered down, so it will always returns
> > fail hence break system's suspend, this patch disables imx thermal sensor
> > before suspend and re-enable it after resume.
> > 
> > Signed-off-by: Anson Huang <b20788@freescale.com>
> 
> applied. BTW, this should also be a stable material for 3.12, right?

Right.  That would be great.  Thanks.

Shawn

