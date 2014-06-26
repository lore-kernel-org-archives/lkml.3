Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbaFZSFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:05:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbaFZSFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:05:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] cfq: Increase default value of target_latency
References: <1403683129-10814-1-git-send-email-mgorman@suse.de>
	<1403683129-10814-7-git-send-email-mgorman@suse.de>
	<x491tub65t9.fsf@segfault.boston.devel.redhat.com>
	<20140626161955.GH10819@suse.de>
	<x49simr4ntz.fsf@segfault.boston.devel.redhat.com>
	<20140626174500.GI10819@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 26 Jun 2014 14:04:34 -0400
In-Reply-To: <20140626174500.GI10819@suse.de> (Mel Gorman's message of "Thu,
	26 Jun 2014 18:45:00 +0100")
Message-ID: <x49k3834kel.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

>> And we should probably run our standard set of I/O exercisers at the
>> very least.  But, like I said, it seems like wasted effort.
>> 
>
> Out of curiousity, what do you consider to be the standard set of I/O
> exercisers?

Yes, that was vague, sorry.  I was referring to any io generator that
will perform sequential and random I/O (writes, re-writes, reads, random
writes, random reads, strided reads, backwards reads, etc).  We use
iozone internally, testing both buffered and direct I/O, varying file
and record sizes and across multiple file systems.  Data sets that fall
inside of the page cache tend to have a high standard deviation, so, as
an I/O guy, I ignore those.  ;-)

Cheers,
Jeff
