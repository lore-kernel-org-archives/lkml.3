Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbaD2IGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:06:11 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43700 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060AbaD2IF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:05:58 -0400
Date: Tue, 29 Apr 2014 09:05:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: pm8921: Remove pm8xxx API now that sub-devices use
 regmap
Message-ID: <20140429080553.GD29462@lee--X1>
References: <1397002455-12854-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397002455-12854-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The pm8xxx read/write wrappers are no longer necessary now that
> all the sub-device drivers are using the regmap API. Remove it.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Based on Linus' tip as of a7963eb7f4c4 (Merge branch 'for_linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs, 2014-04-07)
> 
>  drivers/mfd/pm8921-core.c       | 123 +---------------------------------------
>  include/linux/mfd/pm8xxx/core.h |  81 --------------------------
>  2 files changed, 2 insertions(+), 202 deletions(-)
>  delete mode 100644 include/linux/mfd/pm8xxx/core.h

Sorry, this slipped through the gaps.

Diff looks great. Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
