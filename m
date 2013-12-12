Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3LLUl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:41:29 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53055 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3LLUlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:41:25 -0500
MIME-Version: 1.0
In-Reply-To: <1386787041-6035-3-git-send-email-syin@broadcom.com>
References: <1381174108-25168-1-git-send-email-syin@broadcom.com>
	<1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1386787041-6035-3-git-send-email-syin@broadcom.com>
Date: Thu, 12 Dec 2013 21:41:25 +0100
Message-ID: <CACRpkdYYR78Q5rQZb21oD8EVcR7x0x0yFJgun7mqZ6NTnWvJ+Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] pinctrl: Adds slew-rate, input-enable/disable
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
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

On Wed, Dec 11, 2013 at 7:37 PM, Sherman Yin <syin@broadcom.com> wrote:

> This commit adds slew-rate and input-enable/disable support for pinconf
> -generic.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> ---
> v3: added to patchset

I really like this patch and would like to apply it but I want to give
the device tree people a few days to think about it.

Yours,
Linus Walleij
