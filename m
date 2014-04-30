Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422652AbaD3OCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:02:31 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:57884 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaD3OC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:02:29 -0400
Date: Wed, 30 Apr 2014 15:02:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org
Subject: Re: [PATCH 09/10] ARM: vexpress: move HBI check to sysreg driver
Message-ID: <20140430140223.GP29462@lee--X1>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
 <1398707877-22596-10-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398707877-22596-10-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The last reason for static memory mapping is the HBI (board
> identification number) check early in the machine code.
> 
> Moving the check to the sysreg driver makes it possible to
> completely remove the early mapping and init functions.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  arch/arm/mach-vexpress/v2m.c  | 49 -------------------------------------------
>  drivers/mfd/vexpress-sysreg.c | 30 ++++++++++----------------
>  include/linux/vexpress.h      |  1 -
>  3 files changed, 11 insertions(+), 69 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

How do you want this patch handled?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
