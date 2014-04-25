Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaDYAb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:31:59 -0400
Received: from imx12.toshiba.co.jp ([61.202.160.132]:36202 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaDYAb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:31:57 -0400
Message-Id: <201404250031.s3P0V2DY022219@toshiba.co.jp>
Date: Fri, 25 Apr 2014 09:31:02 +0900
From: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYg==?= =?UTF-8?B?ZWNrZXI=?= 
	<fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
References: <cover.1395322529.git.viresh.kumar@linaro.org>	<201404240725.s3O7PrUv003720@toshiba.co.jp>	<CAKohpokt-O3BAGMzE_=heVBZQOwp0C7eT8ZA2485DgNi3+Xcqg@mail.gmail.com>	<201404240832.s3O8WHd0011014@toshiba.co.jp>	<CAKohpokk4rGeP3QfVT5_HBO4pc=22yPBLV78D++y1Ab72y1OJQ@mail.gmail.com>	<201404240924.s3O9OYCC021688@toshiba.co.jp> <CAKohponA4-cm2_FB=8R8aVEWNhtUfOUebcfzn7W+XR0zKHCtxw@mail.gmail.com>
In-Reply-To: <CAKohponA4-cm2_FB=8R8aVEWNhtUfOUebcfzn7W+XR0zKHCtxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I can't keep it as a separate patch and so would be required to merge
>> it into my original patch..
> 
> And the reason being: "No patch is supposed to break things, otherwise
> git bisect wouldn't work smoothly".. And so git bisect would complain
> this issue after my patch and so I have to merge the fixes you gave into
> the original patch as its not yet merged.
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Ok, no problem then.

Thanks,
Daniel

-- 
Toshiba Corporate Software Engineering Center
Daniel SANGORRIN
E-mail:  daniel.sangorrin@toshiba.co.jp
