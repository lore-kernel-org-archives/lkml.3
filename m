Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaKHKoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 05:44:39 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:56849 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbaKHKoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 05:44:37 -0500
Message-ID: <545DF40B.9000803@linux.vnet.ibm.com>
Date: Sat, 08 Nov 2014 16:14:27 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, rjw@rjwysocki.net
CC: nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 3/6] sched: idle: Get the next timer event and pass
 it the cpuidle framework
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org> <1415370687-18688-4-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1415370687-18688-4-git-send-email-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110810-0033-0000-0000-0000029D191A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 08:01 PM, Daniel Lezcano wrote:
> Following the logic of the previous patch, retrieve from the idle task the
> expected timer sleep duration and pass it to the cpuidle framework.
> 
> Take the opportunity to remove the unused headers in the menu.c file.
> 
> This patch does not change the current behavior.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Reviewed-by: Len Brown <len.brown@intel.com>
> ---

This patch looks good to me as well.

Reviewed-by: Preeti U. Murthy

