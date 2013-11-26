Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3KZM7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:59:40 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45923 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3KZM7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:59:37 -0500
Message-ID: <52949B2D.3090208@linaro.org>
Date: Tue, 26 Nov 2013 20:59:25 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
CC: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] sched/nohz_full: give correct cpu load for nohz_full
 cpu
References: <1385102235-25664-1-git-send-email-alex.shi@linaro.org> <1385102235-25664-5-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1385102235-25664-5-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 02:37 PM, Alex Shi wrote:
> When a nohz_full cpu in tickless mode, it may update cpu_load in
> following chain:
> __tick_nohz_full_check
>     tick_nohz_restart_sched_tick
>         update_cpu_load_nohz
> then it will be set a incorrect cpu_load: 0.
> This patch try to fix it and give it the correct cpu_load value.

Frederic,

Would you like to give some comments on this patch?


-- 
Thanks
    Alex
