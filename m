Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaEMD7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:59:47 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:41943 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850AbaEMD7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:59:46 -0400
Message-ID: <537198AE.3050100@semaphore.gr>
Date: Tue, 13 May 2014 06:59:42 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yuyang Du <yuyang.du@intel.com>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Smythies <dsmythies@telus.net>
Subject: Re: [RFC PATCH] cpufreq: intel_pstate: Change the calculation of
 next pstate
References: <5368255D.3090207@semaphore.gr> <536BEE89.3040602@gmail.com> <536CECB4.1090109@semaphore.gr> <53712F4B.7000101@semaphore.gr> <20140512193453.GB9351@intel.com>
In-Reply-To: <20140512193453.GB9351@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/05/2014 10:34 μμ, Yuyang Du wrote:
> On Mon, May 12, 2014 at 11:30:03PM +0300, Stratos Karafotis wrote:
>> On 09/05/2014 05:56 μμ, Stratos Karafotis wrote:
>>
>> Next performance state = min_perf + (max_perf - min_perf) * load / 100
>>
> Hi,
> 
> This formula is fundamentally broken. You need to associate the load with its
> frequency.

Could you please explain why is it broken? I think the load should be
independent from the current frequency.

Thanks,
Stratos
