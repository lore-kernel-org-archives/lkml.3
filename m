Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaE2HSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 03:18:55 -0400
Received: from ozlabs.org ([103.22.144.67]:56688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbaE2HSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 03:18:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
In-Reply-To: <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org> <1401260039-18189-2-git-send-email-minchan@kernel.org> <CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com> <20140528223142.GO8554@dastard> <CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com> <20140529013007.GF6677@dastard> <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 29 May 2014 15:31:27 +0930
Message-ID: <87oayh6s3s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> Well, we've definitely have had some issues with deeper callchains
> with md, but I suspect virtio might be worse, and the new blk-mq code
> is lilkely worse in this respect too.

I looked at this; I've now got a couple of virtio core cleanups, and
I'm testing with Minchan's config and gcc versions now.

MST reported that gcc 4.8 is a better than 4.6, but I'll test that too.

Cheers,
Rusty.
