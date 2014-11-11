Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaKKXWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 18:22:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbaKKXWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 18:22:07 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Milosz Tanski <milosz@adfin.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio\@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
	<CANP1eJHfWT0Foe+weB1SJkJ10JnOge_g=E8CXBsQNPW7i2+4NA@mail.gmail.com>
	<x49ioilbrfx.fsf@segfault.boston.devel.redhat.com>
	<20141111214240.GV23575@dastard>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 11 Nov 2014 18:21:23 -0500
In-Reply-To: <20141111214240.GV23575@dastard> (Dave Chinner's message of "Wed,
	12 Nov 2014 08:42:40 +1100")
Message-ID: <x49bnod1fyk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Nov 11, 2014 at 12:03:14PM -0500, Jeff Moyer wrote:
>> Milosz Tanski <milosz@adfin.com> writes:
>> 
>> >> Can you write a test (or set of) for fstests that exercises this new
>> >> functionality? I'm not worried about performance, just
>> >> correctness....
>> >
>> > Sure thing. Can you point me at the fstests repo? A quick google
>> > search reveals lots of projects named fstests, most of them abandoned.
>> 
>> I think he's referring to xfstests.  Still, I think that's the wrong
>> place for functional testing.  ltp would be better, imo.
>
> I don't follow. Can you explain why is xfstests be the wrong place
> to exercise this functionality and what makes ltp a better choice?

Right, I should have made a case for that.  ltp already has test cases
for system calls such as readv/writev (though they are woefully
inadequate).  It simply looked like a better fit to me.  For some reason
I view xfstests as a regression test suite, but I know that isn't
strictly true.

If you feel xfstests is a better place, and Ted makes a good case for
that choice, then that's fine with me.  I'm not, as Ted worried,
insisting on putting test cases into ltp.  :)  I was expressing my
opinion, and am happy for the dialog.

Cheers,
Jeff
