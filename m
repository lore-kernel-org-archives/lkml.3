Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaIWOrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:47:19 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42264 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbaIWOrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:47:13 -0400
MIME-Version: 1.0
In-Reply-To: <1410258037-32024-2-git-send-email-pramod.gurav@smartplayin.com>
References: <1410258037-32024-1-git-send-email-pramod.gurav@smartplayin.com>
	<1410258037-32024-2-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 23 Sep 2014 16:47:12 +0200
Message-ID: <CACRpkdbx6f-T+20MnGQxKyi6Zpnz3ujipfjwZ+hmnby2EppOtg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] pinctrl: at91: Fix error handling while doing gpiochio_irqchip_add
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 12:20 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch removes a call to panic function when gpiochio_irqchip_add
> fails and just returns the error to the calling function.
> Same return value is used to handle the error case and adds a lable
> to release resources on error.
> The error message has been improved to indicate failure to add irqchip
> to gpiochip.
>
> This also changes first argument to function at91_gpio_of_irq_setup from
> struct device_node to struct platform_device. Because The device_node
> argument was anyway not being used. Passed pdev so that on failure dev_err
> can use &pdev->dev and log can be associated with proper device.
>
> CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Patch applied.

Yours,
Linus Walleij
