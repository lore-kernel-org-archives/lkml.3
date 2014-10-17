Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaJQIDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:03:13 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35491 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQIDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:03:08 -0400
MIME-Version: 1.0
In-Reply-To: <50B33AC5ED75F74F991980326F1C438D0FBECEA6@PGSMSX108.gar.corp.intel.com>
References: <1411726047-3224-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <CAAVeFuKcK_Ave41S6gVBE1ZQda22WPDgDxpCatkmccn3uNmyEQ@mail.gmail.com> <50B33AC5ED75F74F991980326F1C438D0FBECEA6@PGSMSX108.gar.corp.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 17 Oct 2014 17:02:47 +0900
Message-ID: <CAAVeFu+HioBqoT85B1-wwOfad8Sq3zFreY2N9YaJLq7JtiuqEA@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] Enable Quark X1000 support in gpio-sch
To: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 12:41 PM, Chang, Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: Alexandre Courbot [mailto:gnurou@gmail.com]
>> Sent: 09 October, 2014 2:29 PM
>> To: Chang, Rebecca Swee Fun
>> Cc: Linus Walleij; Westerberg, Mika; GPIO Subsystem Mailing List; Linux Kernel
>> Mailing List
>> Subject: Re: [PATCHv2 0/3] Enable Quark X1000 support in gpio-sch
>>
>> On Fri, Sep 26, 2014 at 7:07 PM, Chang Rebecca Swee Fun
>> <rebecca.swee.fun.chang@intel.com> wrote:
>> > Hi,
>> >
>> > This is a revised version for gpio-sch.
>> >
>> > Change log for V2:
>> > Patch 1:
>> > - Move sch_gpio_get() and sch_gpio_set() to avoid forward declaration.
>> > - Changed sch_gpio_enable()/sch_gpio_disable() to sch_gpio_register_set()/
>> >   sch_gpio_register_clear().
>> >
>> > Patch 3:
>> > - Changed all sch_gpio_enable()/sch_gpio_disable() to
>> sch_gpio_register_set()/
>> >   sch_gpio_register_clear().
>> >
>> > Version 1:
>> > This patch series is about enabling legacy GPIO support for Quark X1000.
>> > The patches were developed on top of Mika Westerberg's commit on
>> > consolidating core and resume banks. Please refer to the link below
>> > for more information about his commit.
>> > https://lkml.org/lkml/2014/8/17/13
>>
>> Sorry for the late review. I tried to apply the patch you mentioned above before
>> your series, and even Mika's patch won't apply on Linus'
>> devel branch or today's -next. This make it difficult to make a good review.
>> Could you rebase and resend this series once all its dependencies have been
>> merge by Linus W. ?
>
> Hi, I've noticed that Mika had sent a V2series on his work. Referring to his submission in: https://lkml.org/lkml/2014/9/16/213, this patch was able to patch on today's kernel tree. The patches on my series are able to patch in too. Do I need to resend since there is no changes on my side?

I got your v3 applied on top of Linus' devel tree and Mika's patch
without any issue. Thanks.
