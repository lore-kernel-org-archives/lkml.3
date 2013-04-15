Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3DOGRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:17:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:43332 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3DOGRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:17:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,473,1363158000"; 
   d="scan'208";a="322350790"
Message-ID: <516B9B57.3030902@intel.com>
Date: Mon, 15 Apr 2013 14:16:55 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Len Brown <lenb@kernel.org>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com> <20130412162348.GE2368@pd.tnic> <516A0652.8040505@intel.com> <20130414155925.GC20547@pd.tnic> <516B9859.70004@intel.com>
In-Reply-To: <516B9859.70004@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 02:04 PM, Alex Shi wrote:
> On 04/14/2013 11:59 PM, Borislav Petkov wrote:
>> > On Sun, Apr 14, 2013 at 09:28:50AM +0800, Alex Shi wrote:
>>> >> Even some scenario the total energy cost more, at least the avg watts
>>> >> dropped in that scenarios.
>> > 
>> > Ok, what's wrong with x = 32 then? So basically if you're looking at
>> > avg watts, you don't want to have more than 16 threads, otherwise
>> > powersaving sucks on that particular uarch and platform. Can you say
>> > that for all platforms out there?
> The cpu freq boost make the avg watts higher with x = 32, and also make
> higher power efficiency. We can disable cpu freq boost for this if we
> want lower power consumption all time.
> But for my understanding, the power efficient is better way to save power.

BTW, lowest p-state, no freq boost and plus this powersaving policy will
give the lowest power consumption.

And I need to say again. the powersaving policy just effect on system
under utilisation. when system goes busy, it won't has effect.
performance oriented policy will take over balance behaviour.

-- 
Thanks Alex
