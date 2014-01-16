Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaAPN2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:28:19 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:38682 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaAPN2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:28:14 -0500
MIME-Version: 1.0
In-Reply-To: <1387592016-13740-5-git-send-email-syin@broadcom.com>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-5-git-send-email-syin@broadcom.com>
Date: Thu, 16 Jan 2014 14:28:13 +0100
Message-ID: <CACRpkdag2A1GpPGkmLijdDNw4C+6-WLctSFBLQA+LBLeqBch1A@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] pinctrl: Enable pinctrl for Broadcom Capri SoCs
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

> Enable pinctrl for Broadcom Capri (BCM281xx) SoCs.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>

I've applied this to the pinctrl tree as well.

Same thing here: if it conflicts with ARM SoC it goes out.

Yours,
Linus Walleij
