Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbaHYOFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:05:04 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53754 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbaHYOFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:05:00 -0400
Message-ID: <1408975491.5256.42.camel@iivanov-dev>
Subject: Re: [PATCH v3 6/6] ARM: dts: qcom: Add APQ8074 Dragonboard PMIC
 GPIO bindings
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 25 Aug 2014 17:04:51 +0300
In-Reply-To: <20140820230612.GE16274@sonymobile.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
	 <1407771634-14946-7-git-send-email-iivanov@mm-sol.com>
	 <20140820230612.GE16274@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 16:06 -0700, Bjorn Andersson wrote:
> On Mon 11 Aug 08:40 PDT 2014, Ivan T. Ivanov wrote:
> > diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard-pmics-pins.dtsi b/arch/arm/boot/dts/qcom-apq8074-dragonboard-pmics-pins.dtsi
> [...]
> > +
> > +&pm8941_gpios {
> > +
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&pm8941_gpios_default>;
> > +
> > +	pm8941_gpios_default: default {
> > +		group-1 {
> > +			pins = "gpio1", "gpio2", "gpio5", "gpio29";
> > +			function = PMIC_GPIO_FUNC_NORMAL;
> 
> This looks really strange, I can't get myself to stop thinking that you forgot
> the <> around this (I know it's a string). I don't like these defines.

Same here, any suggestions? Except function tables in driver :-)

> 
> > +			input-enable;
> > +			power-source = <PM8941_GPIO_S3>;
> > +			qcom,pull-up-strength = <PMIC_GPIO_PULL_UP_30>;
> > +		};
> > +		group-6 {	/* TUSB3_HUB-RESET */
> 
> Why not name the nodes something useful?
> If you name it tusb3-hub-reset you can skip the comment.

Sure.
 
> Regards,
> Bjorn

Thanks, 
Ivan

