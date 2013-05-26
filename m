Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3EZMDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 08:03:08 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:51895 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab3EZMDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 08:03:04 -0400
Date: Sun, 26 May 2013 08:02:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: Stupid VFS name lookup interface..
Message-ID: <20130526120251.GA32729@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Paris <eparis@redhat.com>,
	James Morris <james.l.morris@oracle.com>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
 <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
 <20130525165710.GC25399@ZenIV.linux.org.uk>
 <51A1040A.80003@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A1040A.80003@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 11:33:46AM -0700, Casey Schaufler wrote:
> Now I'll put on my Smack maintainer hat. Performance improvement is
> always welcome, but I would rather see attention to performance of
> the LSM architecture than SELinux specific hacks. The LSM blob
> pointer scheme is there so that you (Linus) don't have to see the
> dreadful things that we security people are doing. Is it time to
> get past that level of disassociation? Or, and I really hate asking
> this, have you fallen into the SELinux camp?

What part of the LSM architecture are you proposing be optimized?  The
LSM layer is pretty thin, partially because the various different
security approaches don't agree with each other on fairly fundamental
issues.  What sort of optimization opportunities you are suggesting?
Are there changes that can be made that all of the major security LSM
maintainers would actually agree with?

I've been re-reading the thread on LKML which was spawned when SMACK
was proposed for upstream inclusion:

    http://thread.gmane.org/gmane.linux.kernel/585903/focus=586412

Have any of the arguments over the proper security models changed over
or have gotten resolved over the past six years, while I haven't been
looking?

						- Ted
