Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3IIXjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:39:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58695 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3IIXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:39:08 -0400
Message-ID: <522E5C18.7040007@codeaurora.org>
Date: Mon, 09 Sep 2013 16:39:04 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ARM: msm: Create a common board-dt and config ARCH_MSM_DT
References: <1378769094-14042-1-git-send-email-rvaswani@codeaurora.org> <1378769094-14042-2-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1378769094-14042-2-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/13 16:24, Rohit Vaswani wrote:
> diff --git a/arch/arm/mach-msm/board-dt.c b/arch/arm/mach-msm/board-dt.c
> new file mode 100644
> index 0000000..16e6183
> --- /dev/null
> +++ b/arch/arm/mach-msm/board-dt.c
> @@ -0,0 +1,32 @@
> +/* Copyright (c) 2010-2012,2013 The Linux Foundation. All rights reserved.

Hm.. I meant 2010-2013. Maybe David can fix that when he picks it up.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

