Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3EHOIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:08:35 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:31918
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329Ab3EHOIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:08:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 7
X-BigFish: VS7(z329eqz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 8 May 2013 21:53:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
CC: Fabio Estevam <fabio.estevam@freescale.com>, <kernel@pengutronix.de>,
        <festevam@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] pwm: pwm-mxs: Let device core handle pinctrl
Message-ID: <20130508135317.GB26072@S2101-09.ap.freescale.net>
References: <1367863561-11534-1-git-send-email-fabio.estevam@freescale.com>
 <1367863561-11534-6-git-send-email-fabio.estevam@freescale.com>
 <87d2t1n0ze.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87d2t1n0ze.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 02:51:33PM +0300, Alexander Shishkin wrote:
> Fabio Estevam <fabio.estevam@freescale.com> writes:
> 
> > Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> > we can rely on device core for handling pinctrl.
> >
> > So remove devm_pinctrl_get_select_default() from the driver. 
> >
> > Cc: Thierry Reding <thierry.reding@avionic-design.de>
> > Cc: <linux-kernel@vger.kernel.org>
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> > ---
> >  drivers/pwm/pwm-mxs.c |    6 ------
> >  1 file changed, 6 deletions(-)
> 
> Looks good, can we have some tested-by from imx guys?

I'm not sure why you're interested in this patch instead of
"[PATCH 01/13] usb: chipidea: ci13xxx_imx: Let device core handle
pinctrl".  I tested both patches, so

Tested-by: Shawn Guo <shawn.guo@linaro.org>

