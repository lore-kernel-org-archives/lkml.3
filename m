Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3DVEzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 00:55:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41460 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3DVEzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 00:55:06 -0400
MIME-Version: 1.0
In-Reply-To: <51713B86.2090001@neotion.com>
References: <51713B86.2090001@neotion.com>
Date: Mon, 22 Apr 2013 13:55:04 +0900
Message-ID: <CAKYAXd_xa--1QpFCdz3Kj0mKF3cvtxFn-xL3QGWZyXPO4Y79ng@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add boot_enable attribute to eMMC device for boot
 mode operation selection
From: Namjae Jeon <linkinjeon@gmail.com>
To: narmstrong@neotion.com
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/19, Neil Armstrong <narmstrong@neotion.com>:
> Since eMMC 4.3 a special boot mode operation was introduced to retrieve
> data from the eMMC device with a very simple procedure. Since the Linux
> kernel exports these device boot partitions, it may be useful to select
> the boot partition from the user space.
>
> The patch has been tested on a Toshiba eMMC conforming with eMMC 4.5
> specifications.
Hi Neil.
We can be enable boot partition using mmc-utils.
See this address.
https://git.kernel.org/cgit/linux/kernel/git/cjb/mmc-utils.git/commit/?id=7bd1320b2cb38f040ab5cf017d17e283496690bf

So, I don't think this patch is useful.
If you consider to be disable boot partition, you can try to update
mmc-utils base on the address I shared.

Thanks.
>
> Neil Armstrong (3):
>   Add BOOT_PARTITION_ENABLE definition to MMC EXT_CSD PART_CONFIG
>   Add boot_enable sysfs attribute to select MMC boot operation
>     partition
>   Add Documentation for MMC boot_enable attribute
>
>  Documentation/mmc/mmc-dev-parts.txt |    6 +++
>  drivers/mmc/card/block.c            |   72
> ++++++++++++++++++++++++++++++++++-
>  include/linux/mmc/mmc.h             |    1 +
>  3 files changed, 78 insertions(+), 1 deletions(-)
>
>
>
