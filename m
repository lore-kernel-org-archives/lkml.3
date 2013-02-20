Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743Ab3BTIy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:54:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:24628 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933556Ab3BTIy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:54:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="293470691"
Message-ID: <51248F59.2060900@intel.com>
Date: Wed, 20 Feb 2013 16:54:49 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: peterz@infradead.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Subject: Re: [patch v5 10/15] sched: packing transitory tasks in wake/exec
 power balancing
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>  <1361164062-20111-11-git-send-email-alex.shi@intel.com>  <20130218084439.GB10009@lge.com> <5121ECD9.3020300@intel.com>  <5124654E.8040001@intel.com> <1361346030.5919.63.camel@marge.simpson.net>  <51248541.3030004@intel.com> <1361349823.5919.78.camel@marge.simpson.net>
In-Reply-To: <1361349823.5919.78.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 04:43 PM, Mike Galbraith wrote:
>> > 
>> > Sounds reasonable too.
>> > 
>> > I have no idea of the of the decision now.
>> > And guess many guys dislike to use a knob to let user do the choice.
> Nobody likes seeing yet more knobs much, automagical is preferred.
> Trouble with automagical heuristics usage is that any heuristic will
> inevitably get it wrong sometimes, so giving the user control over usage
> is IMHO a good thing.. and once we give the user the choice, we must
> honor it, else what was the point?
> 
> Anyway, fwiw, I liked what I saw test driving the patch set..
> 
>> > What's your opinions, Peter?
> ..but maintainer opinions carry more weight than mine, even to me ;-)

:) Yes, maintainers usually heard enough arguments and can balance them...


-- 
Thanks Alex
