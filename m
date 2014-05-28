Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaE1XY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:24:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43508 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbaE1XY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:24:28 -0400
Message-ID: <53866F8D.6030809@zytor.com>
Date: Wed, 28 May 2014 16:21:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, rusty@rustcorp.com.au, mst@redhat.com,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
References: <1401260039-18189-1-git-send-email-minchan@kernel.org> <1401260039-18189-2-git-send-email-minchan@kernel.org> <20140528101401.43853563@gandalf.local.home> <f00f9b56-704d-4d03-ad0e-ec3ba2d122fd@email.android.com> <20140528221118.GN8554@dastard> <5386664A.5060304@zytor.com> <20140528231708.GE6677@dastard>
In-Reply-To: <20140528231708.GE6677@dastard>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 04:17 PM, Dave Chinner wrote:
>>
>> You were the one calling it a canary.
> 
> That doesn't mean it's to blame. Don't shoot the messenger...
> 

Fair enough.

	-hpa


