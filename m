Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3J0IDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 04:03:52 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:35602 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3J0IDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 04:03:48 -0400
MIME-Version: 1.0
In-Reply-To: <20131027071407.GA11683@leaf>
References: <20131024122255.GI9378@mwanda>
	<20131024122512.GB9534@mwanda>
	<20131026181709.GB10488@kroah.com>
	<20131027013402.GA7146@leaf>
	<526CA7D4.1070904@alum.mit.edu>
	<20131027071407.GA11683@leaf>
Date: Sun, 27 Oct 2013 01:03:47 -0700
Message-ID: <CANN689HctBYZfU+OQ7movFFWNm6rwUdU7G-ExxhPcBPg1KF8Jw@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] commit: Add -f, --fixes <commit>
 option to add Fixes: line
From: Michel Lespinasse <walken@google.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Michael Haggerty <mhagger@alum.mit.edu>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        ksummit-attendees@lists.linuxfoundation.org,
        Git Mailing List <git@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 12:14 AM, Josh Triplett <josh@joshtriplett.org> wrote:
>> > +-f <commit>::
>> > +--fixes=<commit>::
>> > +   Add Fixes line for the specified commit at the end of the commit
>> > +   log message.  This line includes an abbreviated commit hash for
>> > +   the specified commit; the `core.abbrev` option determines the
>> > +   length of the abbreviated commit hash used, with a minimum length
>> > +   of 12 hex digits.
>>
>> You might also mention that the "Fixes:" line includes the old commit's
>> subject line.
>
> I only mentioned the abbreviated commit hash because it was necessary to
> explain the factors affecting hash length.  -s, above, doesn't mention
> that the Signed-off-by line includes the name and email address of the
> committer.

I do wonder, if we're going to bake into git the idea that too-short
abbreviated sha1s don't make sense, why don't we just change the
core.abbrev default to 12 everywhere rather than just in this one
command ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
