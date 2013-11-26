Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3KZNFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:05:07 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46347 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3KZNFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:05:03 -0500
Message-ID: <52949C72.8050605@linaro.org>
Date: Tue, 26 Nov 2013 21:04:50 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, mingo@redhat.com,
        peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com
CC: james.hogan@imgtec.com, jason.low2@hp.com, gregkh@linuxfoundation.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] sched: remove cpu_load decay.
References: <1385102235-25664-1-git-send-email-alex.shi@linaro.org> <528F4A78.1080505@linaro.org> <52918ECC.6080707@linaro.org> <529495AF.4020600@linaro.org> <52949972.6090101@linaro.org> <52949BC1.8090001@linaro.org>
In-Reply-To: <52949BC1.8090001@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 09:01 PM, Daniel Lezcano wrote:
> 
> Ok, bad copy-paste, the third test run results with the patchset is wrong.
> 
> hackbench -P -s 4096 -l 1000 -g 10 -f 40
> 38.938                  39.585                               
> 39.363             39.008
> 39.340             38.954
> 38.909             39.273
> 39.095             38.755
> 38.869             39.003
> 39.041             38.945
> 38.939             38.005
> 38.992             38.994
> 38.947             38.855

Oops,
Anyway, at least, no harm on hackbench process testing. :)

-- 
Thanks
    Alex
