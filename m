Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaJ2GpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:45:17 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53073 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaJ2GpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:45:16 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <54508CF8.9040403@lge.com>
Date: Wed, 29 Oct 2014 15:45:12 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        lauraa@codeaurora.org, dan.carpenter@oracle.com, minchan@kernel.org,
        iamjoonsoo.kim@lge.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com
Subject: Re: [PATCHv2 1/3] staging: ion: shrink page-pool by page unit
References: <1414560960-21130-1-git-send-email-gioh.kim@lge.com> <1414560960-21130-2-git-send-email-gioh.kim@lge.com>
In-Reply-To: <1414560960-21130-2-git-send-email-gioh.kim@lge.com>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
> index da2a63c..0ba8aaf 100644
> --- a/drivers/staging/android/ion/ion_system_heap.c
> +++ b/drivers/staging/android/ion/ion_system_heap.c
> @@ -29,7 +29,7 @@
>   static gfp_t high_order_gfp_flags = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN |
>   				     __GFP_NORETRY) & ~__GFP_WAIT;
>   static gfp_t low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN);
> -static const unsigned int orders[] = {8, 4, 0};
> +static const unsigned int orders[] = {8, 6, 4, 0};

Please ignore this. I'll put it in separate patch.
I'm sorry.
