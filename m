Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab3DQPYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:24:20 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61189 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab3DQPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:24:19 -0400
MIME-Version: 1.0
In-Reply-To: <1365964548-4193-1-git-send-email-marex@denx.de>
References: <CACRpkdZ+ku_-SBTXwwwRDh7F2TXzpgpAF3k+Ksn98BNYXximXw@mail.gmail.com>
	<1365964548-4193-1-git-send-email-marex@denx.de>
Date: Wed, 17 Apr 2013 17:24:18 +0200
Message-ID: <CACRpkdb6tkyB2GWhkywY7gOG=MCBVGNaYy40kNo=LEe_shhbWg@mail.gmail.com>
Subject: Re: [PATCH v2] UCB1400: Pass ucb1400-gpio data through ac97 bus
From: Linus Walleij <linus.walleij@linaro.org>
To: Marek Vasut <marex@denx.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean Delvare <jdelvare@suse.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 8:35 PM, Marek Vasut <marex@denx.de> wrote:

> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-kernel <linux-kernel@vger.kernel.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Marek Vasut <marex@denx.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sam, please pick it up if you're also OK with this.

Yours,
Linus Walleij
