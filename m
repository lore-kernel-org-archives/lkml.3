Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaGHLrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:47:43 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:40177 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaGHLrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:47:41 -0400
Message-ID: <1404820033.16296.2.camel@iivanov-dev>
Subject: Re: [PATCH 1/4] pinctrl: qpnp: Qualcomm PMIC pin controller driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 08 Jul 2014 14:47:13 +0300
In-Reply-To: <20140708075247.GP30458@sirena.org.uk>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
	 <1404745893-6379-2-git-send-email-iivanov@mm-sol.com>
	 <20140708075247.GP30458@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 09:52 +0200, Mark Brown wrote:
> On Mon, Jul 07, 2014 at 06:11:30PM +0300, Ivan T. Ivanov wrote:
> 
> > +struct qpnp_pindesc {
> > +	u16 offset;		/* address offset in SPMI device */
> > +	u32 index;		/* offset from GPIO info base */
> > +	u8 type;		/* peripheral hardware type */
> > +	u8 subtype;		/* peripheral hardware subtype */
> > +	u8 major;		/* digital major version */
> > +	u8 num_regs;		/* control register count */
> > +	u8 cache[QPNP_NUM_CTL_REGS]; /* control register cache */
> > +};
> 
> The device uses a regmap, why do you also need to open code a register
> cache here?

Just leftover from downstream driver. Will remove it.

Regards,
Ivan


