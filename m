Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbaKMKub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:50:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:53676 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbaKMKua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:50:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="631308691"
Message-ID: <54648C50.2060104@linux.intel.com>
Date: Thu, 13 Nov 2014 18:47:44 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] PM / Sleep: Timer quiesce in freeze state
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net> <544DE5CF.9040501@linux.intel.com> <20141027074419.GE10501@worktop.programming.kicks-ass.net> <544F4B31.7050308@linux.intel.com> <20141028082503.GN3337@twins.programming.kicks-ass.net> <5450253B.5020802@linux.intel.com> <20141029082432.GV3337@twins.programming.kicks-ass.net> <5451A94F.1090200@linux.intel.com> <alpine.DEB.2.11.1411121558280.3935@nanos> <20141113013707.GQ29390@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1411131008280.3935@nanos>
In-Reply-To: <alpine.DEB.2.11.1411131008280.3935@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/13 17:10, Thomas Gleixner wrote:
> On Thu, 13 Nov 2014, Peter Zijlstra wrote:
>> On Wed, Nov 12, 2014 at 10:09:47PM +0100, Thomas Gleixner wrote:
>> But sure, we can add suspend notifiers to stuff to shut down timers; I
>> should have a patch for at least one of the offenders somewhere. But I
>> really think that we should not be looking at the individual timers for
>> this, none of the other suspend modes care about active timers.
> 
> Fair enough.
>  

If you are okay with the current method to suspend timekeeping entirely,
then we can go further to fix the rest concerns.

Thanks,
-Aubrey
