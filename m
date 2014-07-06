Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbaGFJXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 05:23:11 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42491 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaGFJXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 05:23:09 -0400
MIME-Version: 1.0
In-Reply-To: <1404457379-4193-1-git-send-email-varkab@cdac.in>
References: <1404457379-4193-1-git-send-email-varkab@cdac.in>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 6 Jul 2014 18:22:48 +0900
Message-ID: <CAAVeFuK8oQStjAozf_3e3YTWBx3JYzBxEvLUq6n6uke1qaxXvg@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/gpio/gpio-sch311x: check return value of gpiochip_remove()
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Varka Bhadram <varkab@cdac.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 4:02 PM, Varka Bhadram <varkabhadram@gmail.com> wrote:
> This patch eliminates the following warning
>
> drivers/gpio/gpio-sch311x.c: In function ‘sch311x_gpio_probe’:
> drivers/gpio/gpio-sch311x.c:286:18: warning: ignoring return value of ‘gpiochip_remove’, declared with attribute warn_unused_result

gpiochip_remove() is to have its return value set to void in another
patch, so I'm not sure we need this one in the meantime?
