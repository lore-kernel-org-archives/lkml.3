Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab3C1BQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 21:16:50 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:45854
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514Ab3C1BQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 21:16:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 28 Mar 2013 09:16:36 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Philipp Zabel <p.zabel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        <kernel@pengutronix.de>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v9 RESEND 4/4] ARM: dts: add sram for imx53 and imx6q
Message-ID: <20130328011634.GB5429@S2101-09.ap.freescale.net>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
 <1363776767-2635-5-git-send-email-p.zabel@pengutronix.de>
 <20130327152910.80bf4812a9506d8c2b5fab1a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130327152910.80bf4812a9506d8c2b5fab1a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:29:10PM -0700, Andrew Morton wrote:
> On Wed, 20 Mar 2013 11:52:47 +0100 Philipp Zabel <p.zabel@pengutronix.de> wrote:
> 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> > Acked-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> > Changes since v8:
> >  - Changed device tree compatible string to "mmio-sram"
> > ---
> >  arch/arm/boot/dts/imx53.dtsi |    5 +++++
> >  arch/arm/boot/dts/imx6q.dtsi |    6 ++++++
> 
> This doesn't apply, due to stuff which is pending in linux-next.  I had
> a go at fixing it but ran out of confidence - those files have changed
> significantly.
> 
> Redo and resend, please?

We will merge this patch via IMX tree.

Shawn

