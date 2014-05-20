Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaETQWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:22:47 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:52203 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaETQWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:22:46 -0400
Date: Tue, 20 May 2014 17:22:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [PATCH v4 3/3] mfd: max8997: change irq names to upper case
Message-ID: <20140520162239.GB32496@lee--X1>
References: <1398693358-28336-1-git-send-email-r.baldyga@samsung.com>
 <1398693358-28336-4-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398693358-28336-4-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch changes naming convention of MUIC interrupts form CamelCase
> to upper case. It makes names more readable and consistent with another
> interrupt names in max8997 driver.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     | 32 ++++++++++++++++----------------
>  include/linux/mfd/max8997-private.h | 16 ++++++++--------

For the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

I think this set should go in together via the MFD tree.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
