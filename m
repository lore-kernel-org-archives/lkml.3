Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaATIQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:16:28 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:42768 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaATIQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:16:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140118025600.GS31049@beef>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-1-git-send-email-syin@broadcom.com>
	<1387592016-13740-4-git-send-email-syin@broadcom.com>
	<CACRpkdaPZrR=kEknr3YKDWLd_E+o22Yn19ei7iT6cdbYdbeZ2w@mail.gmail.com>
	<52D98B99.5050604@broadcom.com>
	<20140118025600.GS31049@beef>
Date: Mon, 20 Jan 2014 09:16:24 +0100
Message-ID: <CACRpkdYAANtY=9QtDnYNZLSrF09nTWUH4nK5oJ7mzznS+_=bHA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Sherman Yin <syin@broadcom.com>, "arm@kernel.org" <arm@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
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

On Sat, Jan 18, 2014 at 3:56 AM, Matt Porter <mporter@linaro.org> wrote:

> I wonder if Linus would accept a rename at this point (too late for 3.14
> presumably, but for 3.15) of s/capri/bcm281xx throughout, bcm11351 for
> the compatible string, as we have for the machine compatible, and also
> BCM281XX for the Kconfig option.

Yes, if there is some consensus that this is what we want to do.

I can certainly merge that during the 3.14-rc phase for that matter.

Yours,
Linus Walleij
