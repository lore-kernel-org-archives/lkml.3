Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaJIG3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:29:00 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:61800 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaJIG2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:28:52 -0400
MIME-Version: 1.0
In-Reply-To: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 9 Oct 2014 15:28:31 +0900
Message-ID: <CAAVeFuKcK_Ave41S6gVBE1ZQda22WPDgDxpCatkmccn3uNmyEQ@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] Enable Quark X1000 support in gpio-sch
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 7:07 PM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:
> Hi,
>
> This is a revised version for gpio-sch.
>
> Change log for V2:
> Patch 1:
> - Move sch_gpio_get() and sch_gpio_set() to avoid forward declaration.
> - Changed sch_gpio_enable()/sch_gpio_disable() to sch_gpio_register_set()/
>   sch_gpio_register_clear().
>
> Patch 3:
> - Changed all sch_gpio_enable()/sch_gpio_disable() to sch_gpio_register_set()/
>   sch_gpio_register_clear().
>
> Version 1:
> This patch series is about enabling legacy GPIO support for Quark X1000.
> The patches were developed on top of Mika Westerberg's commit on
> consolidating core and resume banks. Please refer to the link below for
> more information about his commit.
> https://lkml.org/lkml/2014/8/17/13

Sorry for the late review. I tried to apply the patch you mentioned
above before your series, and even Mika's patch won't apply on Linus'
devel branch or today's -next. This make it difficult to make a good
review. Could you rebase and resend this series once all its
dependencies have been merge by Linus W. ?
