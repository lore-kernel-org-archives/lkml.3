Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3LJN3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:29:19 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47010 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3LJN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:29:17 -0500
Message-ID: <52A71717.8020405@linaro.org>
Date: Tue, 10 Dec 2013 21:28:55 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
CC: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] nohz_full: update cpu load fix in nohz_full
References: <1386074112-30754-1-git-send-email-alex.shi@linaro.org> <1386074112-30754-4-git-send-email-alex.shi@linaro.org> <529EC8E0.6060103@linaro.org>
In-Reply-To: <529EC8E0.6060103@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 02:17 PM, Alex Shi wrote:
> On 12/03/2013 08:35 PM, Alex Shi wrote:
>> > We are not always 0 when update nohz cpu load, after nohz_full enabled.
>> > But current code still treat the cpu as idle. that is incorrect.
>> > Fix it to use correct cpu_load.
> Frederic, Could you like to give some comments?
> 

ping Frederic.

-- 
Thanks
    Alex
