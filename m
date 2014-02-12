Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaBLLUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:20:04 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:40649 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaBLLUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:20:02 -0500
Date: Wed, 12 Feb 2014 11:19:56 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mfd: syscon: Add platform data with a regmap
 config name
Message-ID: <20140212111956.GA15081@lee--X1>
References: <20140211174829.GJ15081@lee--X1>
 <1392141165-14338-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392141165-14338-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Define syscon platform data structure that can be used
> to define a regmap config name. This is particularly useful
> in the regmap debugfs when there is more than one syscon
> device registered, to distinguish the register blocks.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/mfd/syscon.c                 | 4 ++++
>  include/linux/platform_data/syscon.h | 8 ++++++++
>  2 files changed, 12 insertions(+)
>  create mode 100644 include/linux/platform_data/syscon.h

<snip>

> +#ifndef PLATFORM_DATA_SYSCON_H
> +#define PLATFORM_DATA_SYSCON_H
> +
> +struct syscon_platform_data {
> +	        const char *label;
> +};

Provided you fix this up:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
