Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3BKOWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:22:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab3BKOWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:22:05 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-26-git-send-email-koverstreet@google.com>
	<20130208144408.GY2875@htj.dyndns.org>
	<20130208144902.GQ15092@kernel.dk> <20130208212706.GH27179@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 11 Feb 2013 09:21:48 -0500
In-Reply-To: <20130208212706.GH27179@google.com> (Kent Overstreet's message of
	"Fri, 8 Feb 2013 13:27:06 -0800")
Message-ID: <x49txpjj5hf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> On Fri, Feb 08, 2013 at 03:49:02PM +0100, Jens Axboe wrote:
[...]
>> I'd feel a lot better deferring the whole aio/dio performance series for
>> one merge window. There's very little point in rushing it, and I don't
>> think it's been reviewed/tested enough yet.
>
> It could probably use more review, but it has been sitting in linux-next
> and the issues that showed up there are all fixed. You going to help
> review it? :)
>
> I'm not really set on it going in this merge cycle, but testing wise I
> do think it's in pretty good shape and I'm not sure where we're going to
> get more testing from before it goes in.
>
> And Andrew - apologies for not getting you the benchmarks you asked for,
> getting hardware for it has turned out to be more troublesome than I
> expected. Still don't know what's going on with that.

I'll try to get some benchmarking numbers for this patch set.

-Jeff
