Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab3GDIOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:14:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:18443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab3GDIOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:14:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,993,1363158000"; 
   d="scan'208";a="364663957"
Message-ID: <51D52E9A.4030107@intel.com>
Date: Thu, 04 Jul 2013 16:13:14 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <20130704075840.GH18898@dyad.programming.kicks-ass.net>
In-Reply-To: <20130704075840.GH18898@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 03:58 PM, Peter Zijlstra wrote:
> On Thu, Jul 04, 2013 at 01:34:13PM +0800, Alex Shi wrote:
> 
>> If the tsc is marked as constant and nonstop, could we set it as system
>> clocksource when do tsc register? w/o checking it on clocksource_watchdog?
> 
> I'd not do that; the BIOS can still screw you over, we need some validation.

I see. thanks!
> 
> That said; we do need means to disable the clocksource watchdog -- although I
> suppose Frederic might already have provided this for this NOHZ efforts when I
> wasn't looking.
> 


-- 
Thanks
    Alex
