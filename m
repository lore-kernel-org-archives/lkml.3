Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3LKJzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:55:12 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:42119 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3LKJzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:55:05 -0500
Date: Wed, 11 Dec 2013 09:55:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        broonie@kernel.org
Subject: Re: [PATCH 8/8] mfd: pm8921: Use ssbi regmap
Message-ID: <20131211095500.GJ16780@lee--X1>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-9-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386718523-2587-9-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use a regmap so that the pm8xxx read/write APIs can be removed
> once all consumer drivers are converted.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/Kconfig       |  1 +
>  drivers/mfd/pm8921-core.c | 70 +++++++++++++++++++++++++----------------------
>  2 files changed, 39 insertions(+), 32 deletions(-)

As this is regmap related, don't forget to CC Mark Brown when you
resubmit this patchset.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
