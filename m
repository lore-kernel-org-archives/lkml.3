Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbaIQWIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:08:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45193 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbaIQWIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:08:42 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 0/8] qcom SCM updates
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
Date: Wed, 17 Sep 2014 15:08:39 -0700
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lina Iyer <lina.iyer@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B5197E58-92B9-4DA5-8202-966FAE5A3B6A@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 4, 2014, at 6:31 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> The SCM code in the mainline kernel is woefully out of data from what
> is in the downstream msm kernels. Update the code to be at least 
> functionally correct and useful for features like cpuidle and
> suspend.
> 
> Olav Haugan (1):
>  msm: scm: Add logging of actual return code from scm call
> 
> Saravana Kannan (1):
>  msm: scm: Add API to query for service/command availability.
> 
> Stephen Boyd (5):
>  msm: scm: Fix incorrect cache invalidation
>  msm: scm: Get cacheline size from CTR
>  msm: scm: Add atomic SCM APIs
>  msm: scm: Add a feat version query API
>  msm: scm: Move the scm driver to drivers/soc/qcom
> 
> Vikram Mulukutla (1):
>  msm: scm: Flush the command buffer only instead of the entire cache
> 
> arch/arm/mach-qcom/Kconfig                     |   3 -
> arch/arm/mach-qcom/Makefile                    |   4 +-
> arch/arm/mach-qcom/scm-boot.c                  |   2 +-
> drivers/soc/qcom/Kconfig                       |   2 +
> drivers/soc/qcom/Makefile                      |   2 +
> {arch/arm/mach-qcom => drivers/soc/qcom}/scm.c | 162 ++++++++++++++++++++++---
> {arch/arm/mach-qcom => include/soc/qcom}/scm.h |   8 +-
> 7 files changed, 158 insertions(+), 25 deletions(-)
> rename {arch/arm/mach-qcom => drivers/soc/qcom}/scm.c (62%)
> rename {arch/arm/mach-qcom => include/soc/qcom}/scm.h (69%)

I took patches 1-4,7-8.  There are no immediate users for 5-6 at this time.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

