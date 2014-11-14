Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161713AbaKNSqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:46:42 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47540 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161333AbaKNSqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:46:39 -0500
MIME-Version: 1.0
In-Reply-To: <x491tp5ybcc.fsf@segfault.boston.devel.redhat.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
	<x49mw7tyc7e.fsf@segfault.boston.devel.redhat.com>
	<20141114163912.GA23769@redhat.com>
	<x491tp5ybcc.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 14 Nov 2014 13:46:38 -0500
Message-ID: <CANP1eJEhbE3xWYkJyj3ebhPdRLM3Gj+bBxWz40tvB5HXbzgWZg@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 11:51 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dave Jones <davej@redhat.com> writes:
>
>> On Fri, Nov 14, 2014 at 11:32:53AM -0500, Jeff Moyer wrote:
>>
>>  > > Can you write a test (or set of) for fstests that exercises this new
>>  > > functionality? I'm not worried about performance, just
>>  > > correctness....
>>  >
>>  > On the subject of testing, I added support to trinity (attached,
>>  > untested).  That did raise one question.  Do we expect applications to
>>  > #include <linux/fs.h> to get the RWF_NONBLOCK definition?
>>
>> Trinity will at least need an addition to include/compat.h for
>> older headers that won't have the definition.  Looks ok otherwise.
>
> OK, I'll add that.
>
>> Also, I usually sit on stuff like this until the syscall numbers are
>> in Linus tree. This is 3.19 stuff I presume ?
>> istr akpm picked up execveat recently, so if that goes in first, we'll
>> need to respin this anyway..
>
> Sure.  I just wanted to test with trinity *before* it makes it into the
> kernel.  Crazy, I know.  ;-)

I am happy to help out to make sure it's solid... although deep down
inside I secretly wish that now wasn't the time we decided to start
doing it :)

>
> Cheers,
> Jeff



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
