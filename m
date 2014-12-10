Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaLJJBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:01:53 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:40571 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaLJJBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:01:52 -0500
MIME-Version: 1.0
In-Reply-To: <1418031490-17716-1-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1418031490-17716-1-git-send-email-rebecca.swee.fun.chang@intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 10 Dec 2014 18:01:31 +0900
Message-ID: <CAAVeFuLRpjXy38-auJ4FS-gpdVZ0V=S8BE6X6OkHP0+QCWe3DQ@mail.gmail.com>
Subject: Re: [PATCHv5 0/2] Enable Quark X1000 support in gpio-sch
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 6:38 PM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:
> Hi all,
>
> This is a revised version for enabling Quark X1000 support in gpio-sch.
> This version of patch series had changed according to the feedback provided
> by Alexandre and Linus.
>
> Change log for V5:
> Patch 1:
> - Change variable curr_dirs to reg_val in order to make driver code easier to
>   understand.
>
> Patch 3:
> - Dropped patch 3 for now. We need to re-design the driver's IRQ implementation.
>
> The patches need to be patched on top of Mika Westerberg's commit at:
> gpio: sch: Consolidate core and resume banks
> http://marc.info/?l=linux-kernel&m=141392647225885&w=2
>
> The patches has been verifed and tested working on Galileo Board. GPIO sysfs
> was able to export gpio pins and changing pin direction. GPIO values were
> able to controlled. One of the GPIO pins which is connected to on-board LED
> was used to test GPIO functionality. We are able to turn the LED on/off by
> changing the pin direction and pin value.

I think these patches are good to go, if Linus is ok with it. Nice job
making this driver simpler and more legible. Looking forward to seeing
the IRQ implementation!
