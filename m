Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3CFQig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:38:36 -0500
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:39500 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653Ab3CFQif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:38:35 -0500
Date: Wed, 6 Mar 2013 16:38:33 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SLAB changes for v3.9-rc1
In-Reply-To: <CA+55aFxV=xs9a8H1YbFSjNzMeebixFaA4hShdHwfRKndFU8FUA@mail.gmail.com>
Message-ID: <0000013d40918dba-4b124e7a-e591-4e75-b568-e1ff9a8d9f03-000000@email.amazonses.com>
References: <alpine.LFD.2.02.1303041234550.3981@tux.localdomain> <CA+55aFxV=xs9a8H1YbFSjNzMeebixFaA4hShdHwfRKndFU8FUA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Mar 2013, Linus Torvalds wrote:

> On Mon, Mar 4, 2013 at 2:35 AM, Pekka Enberg <penberg@kernel.org> wrote:
> >
> > It contains more of Christoph's SLAB unification work that reduce the
> > differences between different slab allocators. The code has been sitting
> > in linux-next without problems.
> >
> > If you feel this is inappropriate for -rc2, just skip the pull and I'll
> > requeue it for 3.10.
>
> Ugh. It only came a day late, and if you had pushed a bit harder, I'd
> have pulled it. But when you put it that way, I really cannot see any
> valid reason why it cannot wait, and so I think I'll just expect it
> for the next release.
>
> If you change your mind and realize that it fixes some major bug and
> really needs to be pulled after all, holler.

Well this stuff was already ready for 3.8 and missed that merge period as
well. There are a couple of bug fixes included as well. It is the basis
for more common code between allocators. Most of it is renaming things so
that fields have a common name which enables more code sharing.


