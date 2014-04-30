Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbaD3I0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:26:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42021 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079AbaD3I0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:26:33 -0400
Message-ID: <1398846369.19894.21.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 1/3] of: Add vendor prefix for Linear Technology
 Corporation
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
Date: Wed, 30 Apr 2014 10:26:09 +0200
In-Reply-To: <CAL_JsqJLhino_s+BhiApRYBtbUvyrn4KF0Zax7YKP_HYLye5gw@mail.gmail.com>
References: <1398789430-23897-1-git-send-email-p.zabel@pengutronix.de>
	 <CAL_JsqJLhino_s+BhiApRYBtbUvyrn4KF0Zax7YKP_HYLye5gw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 29.04.2014, 15:44 -0500 schrieb Rob Herring:
> On Tue, Apr 29, 2014 at 11:37 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Add Linear Technology Corporation to the list of device tree vendor prefixes.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> > index 0f01c9b..3d27991 100644
> > --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> > +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> > @@ -65,6 +65,7 @@ lantiq        Lantiq Semiconductor
> >  lg     LG Corporation
> >  linux  Linux-specific binding
> >  lsi    LSI Corp. (LSI Logic)
> > +ltc    Linear Technology Corporation
> 
> 
> Following the use of stock symbols, this should be lltc. Is this already in use?

[Added Tim Harvey to Cc]

That depends on the definition of 'in use'.

grep found arch/arm/boot/dts/imx6qdl-gw5[123]xx.dtsi containing
a "ltc,ltc3676" compatible, but I haven't seen the corresponding
driver yet. I suspect at this point we still can switch to use lltc
instead of ltc as vendor prefix without hurting anybody.

regards
Philipp

