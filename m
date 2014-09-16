Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaIPTyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:54:07 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:55668 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaIPTyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:54:05 -0400
MIME-Version: 1.0
In-Reply-To: <x491trbz81r.fsf@segfault.boston.devel.redhat.com>
References: <cover.1410810247.git.milosz@adfin.com>
	<057d758976db2fcce58e394abaa0d55e48cdeec1.1410810247.git.milosz@adfin.com>
	<x491trbz81r.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 16 Sep 2014 15:54:03 -0400
Message-ID: <CANP1eJE6aETouMj4VA7B4SbwyCACV+E+xrmSLjn6G6-90Eyd+Q@mail.gmail.com>
Subject: Re: [PATCH 2/7] Define new syscalls readv2,preadv2,writev2,pwritev2
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good point. I will put the shared functionality in a static function.

On Tue, Sep 16, 2014 at 3:20 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> writes:
>
>> New syscalls with an extra flag argument. For now all flags except for 0 are
>> not supported.
>
> The blatant copy-n-paste of the vectored functions bothers me.  I'll
> withold judgement until I've seen your next version of the patch series,
> though.
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
