Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaAPNTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:19:14 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:59258 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaAPNTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:19:12 -0500
MIME-Version: 1.0
In-Reply-To: <1387592016-13740-4-git-send-email-syin@broadcom.com>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-4-git-send-email-syin@broadcom.com>
Date: Thu, 16 Jan 2014 14:19:11 +0100
Message-ID: <CACRpkdaPZrR=kEknr3YKDWLd_E+o22Yn19ei7iT6cdbYdbeZ2w@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>, "arm@kernel.org" <arm@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 3:13 AM, Sherman Yin <syin@broadcom.com> wrote:

'> Adds pinctrl driver for Broadcom Capri (BCM281xx) SoCs.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
> v4: - PINCTRL selected in Kconfig, PINCTRL_CAPRI selected in bcm_defconfig
>     - make use of regmap
>     - change CAPRI_PIN_UPDATE from macro to inline function.
>     - Handle pull-up strength arg in Ohm instead of enum

Patch applied. It is really good now! It's late before the merge
window, but you've done a tremendous work on this driver and
I don't want to delay its deployment further.

But note:

>  arch/arm/configs/bcm_defconfig  |    1 +
>  arch/arm/mach-bcm/Kconfig       |    1 +

I've optimistically applied these two hunks of the patch as well,
but if there is any conflict with the ARM SoC tree I will just rebase
the patch and pull these *out*.

ARM SoC maintainers: be warned if something collides.

Yours,
Linus Walleij
