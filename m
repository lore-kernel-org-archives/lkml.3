Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaGaHga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:36:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:46010 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbaGaHg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:36:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="463476960"
Message-ID: <53D9F1FA.6080106@intel.com>
Date: Thu, 31 Jul 2014 15:36:26 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v4 0/9] perf, x86: large PEBS interrupt threshold
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com> <20140731072744.GN19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140731072744.GN19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 03:27 PM, Peter Zijlstra wrote:
> 
> 
> OK, so no feedback on the 'pending' discussions we had wrt PEBS record
> generation?
> 
> No feedback on the correctness aspects of the overflow crap?
> 
> Just a new series, which I then have to dig through to figure out wtf
> changed?
> 
> A quick look at patch 6 reads like you still don't understand the issue
> right. There are no 'collisions' as such in PEBS record generation, or
> are there? See the earlier open discussion.

I'm sure collision only create one PEBS records. Actually, the patch description
was written by Andi.



> 
> _WHY_ are you sending me new patches without sorting the open points
> first?
> 


