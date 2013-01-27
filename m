Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3A0A20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:28:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:22587 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab3A0A2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:28:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,545,1355126400"; 
   d="scan'208";a="248801429"
Date: Sun, 27 Jan 2013 01:28:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        akpm@linux-foundation.org, a.zummo@towertech.it,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 0/4] mfd: palma: add RTC and GPIO support
Message-ID: <20130127002821.GF1174@sortiz-mobl>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Thu, Jan 03, 2013 at 04:16:56PM +0530, Laxman Dewangan wrote:
> This series add the RTC and gpio driver for the TI Palma series PMIC.
> The changes are splitted so that easy to apply in different sub systems.
> 
> Laxman Dewangan (4):
>   mfd: palmas: add rtc irq number as irq resource for palmas-rtc
>   mfd: palmas: add apis to access the Palmas' registers
>   gpio: palmas: Add support for Palams GPIO
>   rtc: palmas: add RTC driver Palmas series PMIC
All 4 patches applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
