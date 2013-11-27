Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3K0Csn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:48:43 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52651 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3K0Csl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:48:41 -0500
Message-ID: <52955D7E.3050206@linaro.org>
Date: Wed, 27 Nov 2013 10:48:30 +0800
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
Subject: Re: [RFC PATCH 0/4] sched: remove cpu_load decay.
References: <1385102235-25664-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1385102235-25664-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 02:37 PM, Alex Shi wrote:
> 	latest kernel 527d1511310a89		+ this patchset
> hackbench -T -g 10 -f 40
> 	23.25"					21.7"
> 	23.16"					19.99"
> 	24.24"					21.53"
> hackbench -p -g 10 -f 40
> 	26.52"					22.48"
> 	23.89"					24.00"
> 	25.65"					23.06"
> hackbench -P -g 10 -f 40
> 	20.14"					19.37"
> 	19.96"					19.76"
> 	21.76"					21.54"
> 
> The git tree for this patchset at:
>  git@github.com:alexshi/power-scheduling.git no-load-idx 

Fengguang,

Did your kernel testing find sth unusual on this 3 patches?

-- 
Thanks
    Alex
