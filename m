Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3I0IHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:07:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42374 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3I0IHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:07:13 -0400
Date: Fri, 27 Sep 2013 09:07:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, swarren@nvidia.com
Subject: Re: [PATCH 1/4] mfd: palmas: remove call of mfd_remove_devices
Message-ID: <20130927080707.GF5100@lee--X1>
References: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
 <1380202431-4868-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380202431-4868-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, Laxman Dewangan wrote:

> The driver only support the device tree and sub modules are populated
> through platform, the registration of sub devices through mfd_add_devices
> has been removed.
> 
> Hence in remove path of the driver, it is not require to call
> mfd_remove_devices.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/mfd/palmas.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
