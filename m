Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3FCUxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:53:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46974 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3FCUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:53:46 -0400
Message-ID: <51AD0259.4010708@codeaurora.org>
Date: Mon, 03 Jun 2013 13:53:45 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] msm: Remove unused file core.h
References: <1369863449-25059-1-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1369863449-25059-1-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping ?

On 5/29/2013 2:37 PM, Rohit Vaswani wrote:
> Commit be2109e13fc6f017040c57615acfe1065723687b removed the usage
> of core.h. Remove the file as well.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>   arch/arm/mach-msm/core.h |    2 --
>   1 files changed, 0 insertions(+), 2 deletions(-)
>   delete mode 100644 arch/arm/mach-msm/core.h
>
> diff --git a/arch/arm/mach-msm/core.h b/arch/arm/mach-msm/core.h
> deleted file mode 100644
> index a9bab53..0000000
> --- a/arch/arm/mach-msm/core.h
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -extern struct smp_operations msm_smp_ops;
> -extern void msm_cpu_die(unsigned int cpu);


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

