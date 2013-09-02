Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3IBQKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:10:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45670 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932158Ab3IBQKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:10:06 -0400
Message-ID: <1378138205.1953.66.camel@joe-AO722>
Subject: Re: Making changes to the Coding Style
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 02 Sep 2013 09:10:05 -0700
In-Reply-To: <9976.1378132260@warthog.procyon.org.uk>
References: <9976.1378132260@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing lkml, Andrew Morton and Linus)

Hi David.

I'm making a few comments to your otherwise unedited
original email sent to me and ksummit-2013-discuss below:

On Mon, 2013-09-02 at 15:31 +0100, David Howells wrote:
> I have some questions about the process of changing the coding style:
>
>  (1) Should there be a procedure for changing the kernel coding style so that
>      people don't find out from checkpatch that what was fine yesterday now
>      gets you moaned at?
> 
>  (2) Where should changes be announced so that enough people see it that there
>      can be discussion?  I suggest that this not be LKML due to the amount of
>      noise.  Perhaps a kernel-announce list?

I do not read ksummit-2013-announce.
This should be sent to lkml as it's the widest list.
Perhaps other lists as well, but certainly lkml at a
minimum.

>  (3) Who maintains the coding style?  Who arbitrates since coding style is
>      very much subjective?
> 
>  (4) Do we actually need to make changes at all when people are generally okay
>      with what we already have?
> 
>  (5) To what extent should local conditions be allowed to prevail?  For
>      example, in CodingStyle, there are different commenting rules for net/
>      and drivers/net/.  There are also unwritten variations in how various
>      bits of the tree are styled.
> 
>  (6) If the coding style does get changed, should existing lines within the
>      kernel then be retroactively changed?
> 
> 
> To illustrate a recent case:
> 
> A patch was posted to LKML to have checkpatch require the removal of "extern"
> from all function prototypes added in patches.  Sadly, I don't manage to read
> much of LKML these days and didn't see the initial posting.  The first I heard
> about this was when patches came my way retroactively fixing up kernel sources
> for which I'm responsible - patches which were firmly NAK'd.
> 
> I posted an objection to the coding style change itself[*] but the patch went
> in to upstream checkpatch anyway.  The first I found out about that was when
> Fengguang's automated git commit compile checker started sending me messages
> about patches that had previously been okay in this regard.
> 
> [*] Note that in this case, I disagree with the suggestion that the extern is
>     just visual noise - to me it's a visual cue.  I grant, however, that this
>     is subjective.
> Does this mean that the checkpatch crew are now the arbiters of the coding
> style, and whatever they decide is best just goes?

I make no such claims.

I do prefer standardized styles and I don't much care
what style is used.  I believe the standardized styles
can habituate developer's reading speeds for the better
and can also reduce the defect rate in new code.

extern is used in .h files far fewer times in function
prototypes than not. (~2:1 in favor of no extern) in
the kernel tree.

> Can we just delete checkpatch entirely?
> 
> Is the CodingStyle file obsolete, since things get put into checkpatch but not
> into CodingStyle?
> 
> </rant>
> 
> David
> 



