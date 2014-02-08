Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaBHD0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 22:26:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52964 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaBHD0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 22:26:08 -0500
Date: Fri, 7 Feb 2014 19:26:07 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] ARM: qcom: Split Qualcomm support into legacy
 and multiplatform
Message-ID: <20140208032607.GC10784@codeaurora.org>
References: <1391725484-6673-1-git-send-email-galak@codeaurora.org>
 <1391725484-6673-4-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391725484-6673-4-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Kumar Gala wrote:
> diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-qcom/platsmp.c
> similarity index 98%
> rename from arch/arm/mach-msm/platsmp.c
> rename to arch/arm/mach-qcom/platsmp.c
> index 251a91e..67823a7 100644
> --- a/arch/arm/mach-msm/platsmp.c
> +++ b/arch/arm/mach-qcom/platsmp.c
> @@ -2,6 +2,7 @@
>   *  Copyright (C) 2002 ARM Ltd.
>   *  All Rights Reserved
>   *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> + *  Copyright (c) 2014 The Linux Foundation. All rights reserved.

We should replace the Code Aurora Forum copyright with Linux
Foundation here.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
