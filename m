Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab3BIQfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 11:35:20 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34115 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760752Ab3BIQfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 11:35:19 -0500
MIME-Version: 1.0
In-Reply-To: <51166e1c.NRfQN8VgI14zuNwf%fengguang.wu@intel.com>
References: <51166e1c.NRfQN8VgI14zuNwf%fengguang.wu@intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 9 Feb 2013 16:34:57 +0000
X-Google-Sender-Auth: FPP9ul5rBxi02CNOJIQuyowwMl0
Message-ID: <CACxGe6tAEX7o9dxNTXtwKwzZHmEteKAS+7uy4j-DTX_2V583tg@mail.gmail.com>
Subject: Re: [grant:gpio/next 10/16] gpiolib.c:undefined reference to `gpiod_unexport'
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex, this is broken when the sysfs interface isn't enabled. Can you
send a fixup patch?

g.

On Sat, Feb 9, 2013 at 3:41 PM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> tree:   git://git.secretlab.ca/git/linux-2.6.git gpio/next
> head:   8a307b35962e42de0f998c6029e8851c61eadb4e
> commit: 5bb47609e8167d733786cb781ada29536385635c [10/16] gpiolib: use descriptors internally
> config: i386-randconfig-b040 (attached as .config)
>
> All error/warnings:
>
>    drivers/built-in.o: In function `gpiod_free':
>>> gpiolib.c:(.text+0xda3): undefined reference to `gpiod_unexport'
>    drivers/built-in.o: In function `gpio_request_one':
>>> (.text+0x147f): undefined reference to `gpiod_export'
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation



--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
