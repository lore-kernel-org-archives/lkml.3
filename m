Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3A1KZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:25:13 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:64027 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3A1KZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:25:10 -0500
MIME-Version: 1.0
In-Reply-To: <51045261.5020709@free-electrons.com>
References: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com>
	<1358889025-8530-3-git-send-email-gregory.clement@free-electrons.com>
	<CACRpkda-N0GrKOeaz4Hji0ef9pSRNPCxW_jLGR28iX-sk0-=tg@mail.gmail.com>
	<51024422.2060503@free-electrons.com>
	<CACRpkdbe1fGVLNyJ+U+ozE32p+_fc-eQ4W1F8OeYC+fryu_dQQ@mail.gmail.com>
	<51045261.5020709@free-electrons.com>
Date: Mon, 28 Jan 2013 11:25:09 +0100
Message-ID: <CACRpkdY+ZwO4CdfAV-DQkVVmG8b2Xi3zaFULNVaGWty6PiOccw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] gpio: pca953x: add support for pca9505
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
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

On Sat, Jan 26, 2013 at 11:02 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> I was about to fix the issues you have pointed but I didn't find anything like
>
> #ifdef CONFIG_ARCH_PXA
>         if (cpu_is_pxa25x()) {
> #ifdef CONFIG_CPU_PXA26x
>                 count = 89;
>                 gpio_type = PXA26X_GPIO;
> #elif defined(CONFIG_PXA25x)
>
> in the pca953x driver! I think you messed up with another patch set!

Yes I did.

Forget about this, thanks for the other nice patches!

Yours,
Linus Walleij
