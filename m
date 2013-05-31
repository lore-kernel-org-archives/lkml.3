Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3EaPDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:03:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51561 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3EaPDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:03:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 2/2] ARM: ux500: Enable HIGHMEM in the u8540 defconfig
Date: Fri, 31 May 2013 17:02:53 +0200
Message-ID: <38058740.G1EqTG95pA@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370010272-25520-2-git-send-email-lee.jones@linaro.org>
References: <1370010272-25520-1-git-send-email-lee.jones@linaro.org> <1370010272-25520-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Vdk21oFnAWQAhoPfleguhU5TtMpMuJ+IDPBkDqPZ0n/
 F8r9xG8poKpJRTQ12F+j2jzE4cwilJ54IholUHeoo/CNbD9KSC
 wE3GDNk8D5V5UG9Nsn/5j2Tn+QzeCP5E64v1bXz8J9o+tIE73C
 y6PNVz84SvcqE+tmE2mNfF7F0XDVBWP/iSCvZeI82e3blUnS09
 1oj1nwUOd/I/xGI1g5VpSkE+PeIuDVPPUP4oHNEb7RZEdcFt/G
 r9WXmA6gNF0n6pmrOFJzzS7Mj036v8P1ozV5S5YYi5rSWB3WmX
 fqyYRNIeIEKs8tvpYL+xvSQy5brr5LW0iSrhzDnDIlNtrf7ziI
 eQHqbE1e1xGL2CxyGRa0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 15:24:32 Lee Jones wrote:
> In order to utilise all of the memory located on ux500 based devices
> we have to enable HIGHMEM. Without it the kernel truncates memory down
> to what's left after the PAGE_OFFSET has been applied, which doesn't
> leave an awful lot, especially if we're running large rootfs' such
> as full Linux desktop distributions or Android.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

How much memory do those devices have? Enabling HIGHMEM is quite expensive.

> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 5439925..808be06 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c

You should probably resend the patch without the second half that got
in it by accident.

	ARnd
