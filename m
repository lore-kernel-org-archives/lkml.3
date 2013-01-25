Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3AYIDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:03:09 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:49985 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3AYIDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:03:06 -0500
MIME-Version: 1.0
In-Reply-To: <1358889025-8530-2-git-send-email-gregory.clement@free-electrons.com>
References: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com>
	<1358889025-8530-2-git-send-email-gregory.clement@free-electrons.com>
Date: Fri, 25 Jan 2013 09:03:04 +0100
Message-ID: <CACRpkdZcTbwNPEnSeCGxxWbZHwayair-s50DWYy1EqpGLNvVZA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] gpio: pca953x: make the register access by GPIO bank
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:10 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> Until now the pca953x driver accessed all the bank of a given register
> in a single command using only a 32 bits variable. New expanders from
> the pca53x family come with 40 GPIOs which no more fit in a 32
> variable. This patch make access to the registers more generic by
> relying on an array of u8 variables. This fits exactly the way the
> registers are represented in the hardware.
>
> It also adds helpers to access to a single register of a bank instead
> of reading or writing all the banks for a given register.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>

This is a nice refactoring and tested too, so patch applied.

I have some nitpicks, may try to fix them with a follow-up
patch but it's certainly not super-important stuff.

Yours,
Linus Walleij
