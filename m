Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3LCI7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:59:13 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61915 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3LCI7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:59:11 -0500
MIME-Version: 1.0
In-Reply-To: <1385249897-16453-3-git-send-email-bjorn.andersson@sonymobile.com>
References: <1385249897-16453-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1385249897-16453-2-git-send-email-bjorn.andersson@sonymobile.com>
	<1385249897-16453-3-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 3 Dec 2013 09:59:10 +0100
Message-ID: <CACRpkdZzoZdeor1K+6onkYMhi98nBJaLHJ+w3EzWt3XLL24-+Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: Add msm8x74 configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 12:38 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:

> Add initial definition of parameters for pinctrl-msm for the msm8x74
> platform.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

SO mostly this looks just normal, nothing to add here except:

> +static struct pinctrl_gpio_range msm8x74_range = {
> +       .name = "msm8x74",
> +       .npins = NUM_GPIO_PINGROUPS
> +};

This thing may not even be needed when adding the range from the
GPIOchip side of the world.

Yours,
Linus Walleij
