Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195AbaE2FRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:17:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46736 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932615AbaE2FRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 01:17:34 -0400
Message-ID: <5386C234.1070301@zytor.com>
Date: Wed, 28 May 2014 22:14:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>
CC: Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>	<1401260039-18189-2-git-send-email-minchan@kernel.org>	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>	<20140528223142.GO8554@dastard>	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>	<20140529013007.GF6677@dastard> <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
In-Reply-To: <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 07:42 PM, Linus Torvalds wrote:
> 
> And Minchan running out of stack is at least _partly_ due to his debug
> options (that DEBUG_PAGEALLOC thing as an extreme example, but I
> suspect there's a few other options there that generate more bloated
> data structures too too).
> 

I have wondered if a larger stack would make sense as a debug option.
I'm just worried it will be abused.

	-hpa


