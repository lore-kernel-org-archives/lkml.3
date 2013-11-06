Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3KFJ3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:29:51 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45558 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab3KFJ3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:29:48 -0500
MIME-Version: 1.0
In-Reply-To: <527835FE.2030102@wwwdotorg.org>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com>
	<051069C10411E24D9749790C498526FA1BE0B7D7@SJEXCHMB12.corp.ad.broadcom.com>
	<CACRpkdYSLxp2M4HghcUdjEYGh-UQ+DaiCGp6yee+Qds6DR9poA@mail.gmail.com>
	<201311050026.56321.heiko@sntech.de>
	<527835FE.2030102@wwwdotorg.org>
Date: Wed, 6 Nov 2013 10:29:47 +0100
Message-ID: <CACRpkdaNnsM1cVTooYH=ePgjtvjrCiwuOD4oyYBZ_uzTYBnA_A@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Sherman Yin <syin@broadcom.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 1:04 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/04/2013 04:26 PM, Heiko Stübner wrote:

> Pure Boolean values should be represented as a valueless property. If
> the property is present, the value is true, otherwise false.
>
> However, pinctrl bindings often don't represent Boolean values, but
> rather tri-states, with the following values:
>
> * Don't touch this configuration option at all (missing)
> * Enable the option (<1>)
> * Disable the option (<0>)

But in this case we actually have these booleans to specify
exactly what we want to do:

bias-disable            - disable any pin bias
bias-high-impedance     - high impedance mode ("third-state", "floating")
bias-bus-hold           - latch weakly
bias-pull-up            - pull up the pin
bias-pull-down          - pull down the pin
bias-pull-pin-default   - use pin-default pull state

Yours,
Linus Walleij
