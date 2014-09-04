Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaIDJLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:11:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35067 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbaIDJLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:11:52 -0400
Message-ID: <54082CD3.1080307@codeaurora.org>
Date: Thu, 04 Sep 2014 14:41:47 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ksm: Remove unused function process_timeout()
References: <1407756165-1906-1-git-send-email-mopsfelder@gmail.com>
In-Reply-To: <1407756165-1906-1-git-send-email-mopsfelder@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 04:52 PM, Murilo Opsfelder Araujo wrote:
> This patch fixes compilation warning:
>
> mm/ksm.c:1711:13: warning: ‘process_timeout’ defined but not used [-Wunused-function]
>
> Signed-off-by: Murilo Opsfelder Araujo<mopsfelder@gmail.com>
> ---
>   mm/ksm.c | 5 -----
>   1 file changed, 5 deletions(-)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index f7de4c0..434a50a 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1708,11 +1708,6 @@ static void ksm_do_scan(unsigned int scan_npages)
>   	}
>   }
>
> -static void process_timeout(unsigned long __data)
> -{
> -	wake_up_process((struct task_struct *)__data);
> -}
> -
>   static int ksmd_should_run(void)
>   {
>   	return (ksm_run&  KSM_RUN_MERGE)&&  !list_empty(&ksm_mm_head.mm_list);


The original KSM patch which introduced this function (by mistake) has 
been re-sent for reviews. So, we can drop this at the moment.

-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
