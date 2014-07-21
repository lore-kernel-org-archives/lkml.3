Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaGUQQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:16:41 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45141 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbaGUQQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:16:39 -0400
Message-ID: <1405959376.28520.3.camel@iivanov-dev>
Subject: Re: [PATCH v2 2/4] pinctrl: qpnp: Qualcomm PMIC pin controller
 driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: divya ojha <odivya77@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Mon, 21 Jul 2014 19:16:16 +0300
In-Reply-To: <CADsdr6Pwa+Vzugy7_-yWePmT6Wj5bpJRDq=qq2KLdG2woioY4g@mail.gmail.com>
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
	 <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
	 <CADsdr6Pwa+Vzugy7_-yWePmT6Wj5bpJRDq=qq2KLdG2woioY4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 21:32 +0530, divya ojha wrote:
> Hi,
> 
> On Thu, Jul 17, 2014 at 8:55 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >
> > This is the pinctrl, pinmux, pinconf and gpiolib driver for the
> > Qualcomm GPIO and MPP sub-function blocks found in the PMIC chips.
> >
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  drivers/pinctrl/Kconfig                       |   12 +
> >  drivers/pinctrl/Makefile                      |    1 +
> >  drivers/pinctrl/pinctrl-qpnp.c                | 1565 +++++++++++++++++++++++++
> >  include/dt-bindings/pinctrl/qcom,pm8xxx-mpp.h |   34 +
> ..
> +       struct device *dev = qctrl->dev;
> > +       struct pinctrl_pin_desc *desc, *descs;
> > +       struct qpnp_padinfo *pad, *pads;
> > +       int idx, ret, cnt, gps, ais, aos, css;
> > +       const char **names, *format;
> > +       unsigned int addr;
> > +
> > +       pads = devm_kcalloc(dev, qchip->npads, sizeof(*pads), GFP_KERNEL);
> 
> when do we free these structures..?

Good description could be found here[1].

Regards,
Ivan

[1] Documentation/driver-model/devres.txt

