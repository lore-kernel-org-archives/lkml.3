Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaGaBIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 21:08:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:62655 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaGaBIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 21:08:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,768,1400050800"; 
   d="scan'208";a="463394290"
Message-ID: <53D996F9.90205@intel.com>
Date: Thu, 31 Jul 2014 09:08:09 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH 3/4] perf/x86/uncore: move SNB-EP/IvyTown specific code
 to seperate file
References: <1406704935-27708-1-git-send-email-zheng.z.yan@intel.com> <1406704935-27708-3-git-send-email-zheng.z.yan@intel.com> <20140730090525.GE19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140730090525.GE19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 05:05 PM, Peter Zijlstra wrote:
> 
> 
> What's Ivytown? Is that IVB-EP or EX or both? I want to fix the subject
> to not mix and match these terms.

It's IVB-EP

> 
> A quick search seems to suggest Ivytown is IVB-EX, which leaves me
> wondering what driver does IVB-EP use?
> 
> Patch 2 seems to be about NHM/WSM/SNB/IVB client parts
> Patch 4 is about NHM/WSM EX parts
> 
> Which leaves SNB/IBV-EP/EX unhandled, does this patch cover all 4 of
> those?


SNB-EP/IVB-EP's uncore subsystem are almost the same as SNB-EP/IVB-EP.

> 
> Which I guess brings me to your total lack of Changelogs, this would've
> made prime changelog material.
> 

