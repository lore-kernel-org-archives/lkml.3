Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3ETIR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 04:17:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab3ETIR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 04:17:56 -0400
Date: Mon, 20 May 2013 10:17:54 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lcapitulino@redhat.com,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] kbuild fix for v3.10-rc2
Message-ID: <20130520081754.GA25645@sepie.suse.cz>
References: <20130517193658.GA32023@pobox.suse.cz>
 <CA+55aFzYf6aCXcCE8=M53OumqvXj_TYb5z7vibe9UDf79xaehw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzYf6aCXcCE8=M53OumqvXj_TYb5z7vibe9UDf79xaehw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 18, 2013 at 10:35:40AM -0700, Linus Torvalds wrote:
> On Fri, May 17, 2013 at 12:36 PM, Michal Marek <mmarek@suse.cz> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git for-next
> >
> > Luiz Capitulino (1):
> >       package: Makefile: unbreak binrpm-pkg target
> >
> >  scripts/package/Makefile |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Hmm. That's not at all what I get. I also get a merge and another
> patch ("kbuild: fix make headers_install when path is too long") and

Sorry, I was on the wrong branch, which happened to be identical to the
rc-fixes branch when I sent the pull request, but not when you read it.
Here is the correct pull request:


In an attempt to improve make rpm-pkg, I broke make binrpm-pkg. Please
pull the fix below.

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes

for you to fetch changes up to f66ba560943ae21f5d1e505bad0a3591823b2b37:

  package: Makefile: unbreak binrpm-pkg target (2013-05-16 09:46:45 +0200)

----------------------------------------------------------------
Luiz Capitulino (1):
      package: Makefile: unbreak binrpm-pkg target

 scripts/package/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

