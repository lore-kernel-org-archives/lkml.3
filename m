Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3I0IBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:01:54 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47354 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3I0IBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:01:52 -0400
Date: Fri, 27 Sep 2013 09:01:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, swarren@nvidia.com
Subject: Re: [PATCH 3/4] mfd: palmas: reset pm_power_off if it is set for the
 device
Message-ID: <20130927080146.GD5100@lee--X1>
References: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
 <1380202431-4868-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380202431-4868-4-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, Laxman Dewangan wrote:

> If Palams supports the system power controller and pm_power_off
> is implemented through the Palmas driver then reset the pm_power_off
> in driver remove.
> 
> This will avoid the call of Palmas driver after removal of driver.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/mfd/palmas.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

Looks good. Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
