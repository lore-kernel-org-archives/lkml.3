Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3DONug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:50:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:3574 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3DONue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="319301684"
Message-ID: <516C059E.20800@intel.com>
Date: Mon, 15 Apr 2013 21:50:22 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
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
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com> <20130412162348.GE2368@pd.tnic> <516A0652.8040505@intel.com> <20130414155925.GC20547@pd.tnic> <516B9859.70004@intel.com> <516B9B57.3030902@intel.com> <20130415095203.GA26524@pd.tnic>
In-Reply-To: <20130415095203.GA26524@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 05:52 PM, Borislav Petkov wrote:
> On Mon, Apr 15, 2013 at 02:16:55PM +0800, Alex Shi wrote:
>> And I need to say again. the powersaving policy just effect on system
>> under utilisation. when system goes busy, it won't has effect.
>> performance oriented policy will take over balance behaviour.
> 
> And AFACU your patches, you do this automatically, right?

Yes
 In which case,
> an underutilized system will have switched to powersaving balancing and
> will use *more* energy to retire the workload. Correct?
> 

For fairness and total threads consideration, powersaving cost quit
similar energy on kbuild benchmark, and even better.

	    17348.850		    27400.458		   15973.776
	    13737.493		    18487.248		   12167.816
	    11057.004		    16080.750		   11623.661

	    17288.102		    27637.176		   16560.375
	    10356.52		    18482.584		   12504.702
	    10905.772		    16190.447		   11125.625
	    10785.621		    16113.330		   11542.140

-- 
Thanks
    Alex
