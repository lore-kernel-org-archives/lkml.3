Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaJXRQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:16:09 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:65184 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbaJXRQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:16:06 -0400
MIME-Version: 1.0
In-Reply-To: <x49k33po42c.fsf@segfault.boston.devel.redhat.com>
References: <cover.1413923420.git.milosz@adfin.com>
	<ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
	<x49k33po42c.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 24 Oct 2014 13:16:04 -0400
Message-ID: <CANP1eJE-gRPNc9xDpAYKHVzcwS+v3AwDb=Dm1CBa=sevSczqjg@mail.gmail.com>
Subject: Re: [PATCH 4/4] vfs: RWF_NONBLOCK flag for preadv2
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 11:55 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> writes:
>
>> Filesystems that generic_file_read_iter will not be allowed to perform
>> non-blocking reads. This only will read data if it's in the page cache and if
>> there is no page error (causing a re-read).
>>
>> Christoph Hellwig wrote the filesystem specify code (cifs, ofs, shm, xfs).
>>
>> Signed-off-by: Milosz Tanski <milosz@adfin.com>
>
> Add in the 2 hunks from the other patches, as suggested by Christoph,
> and you can add my:
>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

I'm aware of the 3 patch series that Christoph sent out shortly after
the previous version of the patchset. Wasn't sure what to do about it.

Christoph, should I apply your last 3 patches to the end of this tree
and send it along with the next submission? Or should I take the first
two combine them with this change and then apply RWF_DSYNC ontop of
it?

- M

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
