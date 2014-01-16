Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaAPNYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:24:11 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36715 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaAPNYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:24:08 -0500
MIME-Version: 1.0
In-Reply-To: <1387592016-13740-3-git-send-email-syin@broadcom.com>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-3-git-send-email-syin@broadcom.com>
Date: Thu, 16 Jan 2014 14:24:07 +0100
Message-ID: <CACRpkdYKrGFpK3Y46-9ah_ssaf-Y6O=O9Usqsw72gjorMKGYNw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] pinctrl: Add pinctrl binding for Broadcom Capri SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
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

> Adds pinctrl driver devicetree binding for Broadcom Capri (BCM281xx) SoCs.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
> v4: Changed valid values for "bias-pull-up" property for I2C pins.  Expanded
>     pin configuration node example.

Patch applied with Mark R's ACK and a copy of his ECG.

Yours,
Linus Walleij
