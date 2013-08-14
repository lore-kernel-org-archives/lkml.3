Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab3HNUuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:50:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43939 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab3HNUuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:50:00 -0400
Date: Wed, 14 Aug 2013 13:49:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: ohad@wizery.com, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>
Subject: Re: [PATCH v3] hwspinlock/msm: Add support for Qualcomm MSM HW
 Mutex block
Message-ID: <20130814204958.GA27999@codeaurora.org>
References: <1376507361-26907-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376507361-26907-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Kumar Gala wrote:
> Add driver for Qualcomm MSM Hardware Mutex block that exists on newer MSM
> SoC (MSM8974, etc).
> 
> CC: Jeffrey Hugo <jhugo@codeaurora.org>
> CC: Eric Holmberg <eholmber@codeaurora.org>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Looks good.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

> ---
> v3:
> * moved dt binding into hwlock/
> * removed smp_mb() as they were not needed
> * cleanup warning
> 
> v2:
> * Fixed init of stride
> * Dealt with a number of comments from Stephen Boyd:
>  - use of <linux/io.h> instead of <asm/io.h>
>  - declaring msm_hwspinlock_of_match once & as const
>  - drop unneccessary () in an if statement
>  - style cleanup to have devm_kzalloc on one line
> 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
