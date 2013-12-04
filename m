Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab3LDPfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:35:51 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:65420 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3LDPfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:35:50 -0500
MIME-Version: 1.0
In-Reply-To: <1385983731-13196-2-git-send-email-panchaxari.prasannamurthy@linaro.org>
References: <1385983731-13196-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
	<1385983731-13196-2-git-send-email-panchaxari.prasannamurthy@linaro.org>
Date: Wed, 4 Dec 2013 16:35:49 +0100
Message-ID: <CACRpkdZ5Bhnfx7e6xWFaqxDp4KqOWMKOUgu==Z4-A7L+K8_CBg@mail.gmail.com>
Subject: Re: [PATCH] ARM:INTEGRATOR: Default enable ARM_PATCH_PHYS_VIRT, AUTO_ZRELADDR
From: Linus Walleij <linus.walleij@linaro.org>
To: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 12:28 PM, panchaxari
<panchaxari.prasannamurthy@linaro.org> wrote:

> ARM_PATCH_PHYS_VIRT and AUTO_ZRELADDR has been enabled as default configs
> to integrator platform.

I have tested this now on Integrator/AP and Integrator/CP and it works
fine, so I'm queueing this for v3.14.

Yours,
Linus Walleij
