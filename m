Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbbANWEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:04:41 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:57825 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbbANWEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:04:39 -0500
Date: Wed, 14 Jan 2015 17:04:34 -0500
From: Jeff Layton <jlayton@poochiereds.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linda Walsh <suse@tlinx.org>, NeilBrown <neilb@suse.de>
Subject: Re: [GIT PULL] please pull file-locking related bugfix for v3.19
 (and v3.18 stable)
Message-ID: <20150114170434.17a9e599@tlielax.poochiereds.net>
In-Reply-To: <CA+55aFwwn_X-snqCk_dy_67g=Neo_fR4fmy=_hSp3izbDTxKRA@mail.gmail.com>
References: <20150114074620.0f80880b@tlielax.poochiereds.net>
	<CA+55aFwwn_X-snqCk_dy_67g=Neo_fR4fmy=_hSp3izbDTxKRA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 10:40:25 +1300
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 15, 2015 at 1:46 AM, Jeff Layton <jlayton@poochiereds.net> wrote:
> >
> >   git://git.samba.org/jlayton/linux.git 52d304eb4eaced9ad04b64ba7cd6ceb5153bbf18
> 
> Ugh. What are you doing?
> 
> Don't send me raw hex numbers of the commit. There's a tag there, and
> it has the name tags/locks-3.19-1, and has your signature on it and
> everything. Sending me the raw hex of the commit object misses that,
> and looks horrible too.
> 
> What kind of odd/broken script do you use?
> 
>            Linus

Ugh, sorry about that. I'm not sure what happened. For some reason
git-request-pull didn't seem to notice the tag. Once I added it as the
"end" arg on the command line, it picked it up. I don't recall ever
having to do that before.

In any case, let's try that again...

----------------------------------------------------------------

The following changes since commit 971780b701946be0d6e34b4abf6eec1ab05ec0c8:

  Merge tag 'gpio-v3.19-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio (2015-01-13 15:29:42 +1300)

are available in the git repository at:

  git://git.samba.org/jlayton/linux.git tags/locks-v3.19-1

for you to fetch changes up to 52d304eb4eaced9ad04b64ba7cd6ceb5153bbf18:

  locks: fix NULL-deref in generic_delete_lease (2015-01-13 07:00:55 -0500)

----------------------------------------------------------------
File-locking related bugfix for v3.19 (and v3.18-stable)

Just a simple bugfix for a regression that I introduced into v3.18 with
the internal lease API overhaul -- mea culpa. Kudos to Linda and Neil
for tracking this down and fixing it.
----------------------------------------------------------------
NeilBrown (1):
      locks: fix NULL-deref in generic_delete_lease

 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jeff Layton <jlayton@poochiereds.net>
