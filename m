Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaBMHxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:53:14 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40780 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaBMHxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:53:12 -0500
Message-ID: <52FC79DF.9060204@linaro.org>
Date: Thu, 13 Feb 2014 15:53:03 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, peterz@infradead.org,
        mingo@kernel.org
CC: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH V2 3/3] sched: Move idle_stamp up to the core
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org> <1391728237-4441-4-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1391728237-4441-4-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 07:10 AM, Daniel Lezcano wrote:
> The idle_balance modifies the idle_stamp field of the rq, making this
> information to be shared across core.c and fair.c. As we can know if the
> cpu is going to idle or not with the previous patch, let's encapsulate the
> idle_stamp information in core.c by moving it up to the caller. The
> idle_balance function returns true in case a balancing occured and the cpu
> won't be idle, false if no balance happened and the cpu is going idle.
> 
> Cc: mingo@kernel.org
> Cc: alex.shi@linaro.org
> Cc: peterz@infradead.org
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: Alex Shi <alex.shi@linaro.org>



-- 
Thanks
    Alex
