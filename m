Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaAUF7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:59:54 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61343 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaAUF7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:59:45 -0500
Message-ID: <52DE0CB7.3040803@linaro.org>
Date: Tue, 21 Jan 2014 13:59:19 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
CC: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@linaro.org>
Subject: Re: [RFC PATCH 1/2] sched/update_avg: avoid negative time
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1390282399-17091-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 01:33 PM, Alex Shi wrote:
> rq->avg_idle try to reflect the average idle time between the cpu idle
> and first wakeup. But in the function, it maybe get a negative value
> if old avg_idle is too small. Then this negative value will be double
> counted in next time calculation. Guess that is not the original purpose,
> so recalibrate it to zero.

Forget this patch, the avg_idle is impossible to get negative.
Sorry for noise!


-- 
Thanks
    Alex
