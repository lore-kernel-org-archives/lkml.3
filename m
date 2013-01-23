Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3AWCAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 21:00:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:10072 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3AWCAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 21:00:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,518,1355126400"; 
   d="scan'208";a="247267381"
Message-ID: <50FF445C.5070909@intel.com>
Date: Wed, 23 Jan 2013 10:01:00 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, namhyung@kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        preeti@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>  <1357375071-11793-10-git-send-email-alex.shi@intel.com>  <50E7EAB1.6020302@intel.com> <50E92DC3.4050906@intel.com>  <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com>  <50EFB1DB.7090804@intel.com> <50FD54EA.4060804@intel.com>  <50FE0575.6090005@intel.com> <1358837740.5782.209.camel@marge.simpson.net>  <50FE44B5.6020004@intel.com> <1358848338.5782.331.camel@marge.simpson.net>  <50FF3090.1090608@intel.com> <1358905643.5752.8.camel@marge.simpson.net>
In-Reply-To: <1358905643.5752.8.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 09:47 AM, Mike Galbraith wrote:
> On Wed, 2013-01-23 at 08:36 +0800, Alex Shi wrote: 
>> On 01/22/2013 05:52 PM, Mike Galbraith wrote:
>>> On Tue, 2013-01-22 at 15:50 +0800, Alex Shi wrote:
>>>
>>>> Thanks for your suggestions and example, Mike!
>>>> I just can't understand the your last words here, Sorry. what the
>>>> detailed concern of you on 'both performance profiles with either
>>>> metric'? Could you like to give your preferred solutions?
>>>
>>> Hm.. I'll try rephrasing.  Any power saving gain will of necessity be
>>> paid for in latency currency.  I don't have a solution other than make a
>>> button, let the user decide whether history influences fast path task
>>> placement or not.  Any other decision maker will get it wrong.
>>
>> Um, if no other objection, I'd like to move the runnable load only used
>> for power friendly policy -- for this patchset, they are 'powersaving'
>> and 'balance', Can I?
> 
> Yeah, that should work be fine.

Thanks for comments! :)
> 
> -Mike
> 


-- 
Thanks Alex
