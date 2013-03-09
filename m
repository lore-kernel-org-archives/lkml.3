Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab3CIE1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 23:27:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760295Ab3CIE1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 23:27:03 -0500
Date: Fri, 8 Mar 2013 23:26:58 -0500
From: Dave Jones <davej@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130309042658.GB1396@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130309003617.GB6743@redhat.com>
 <CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
 <20130309020318.GA11449@redhat.com>
 <CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com>
 <20130309022623.GB11449@redhat.com>
 <20130309025631.GA13188@redhat.com>
 <20130309025752.GA13913@redhat.com>
 <CA+55aFxyOYXnzDoWr7Utr1QLjjMUCON5EGH3FMvGBHxnxMJmQQ@mail.gmail.com>
 <20130309032530.GA19839@redhat.com>
 <87wqthmedi.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqthmedi.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 07:38:33PM -0800, Eric W. Biederman wrote:
 > Dave Jones <davej@redhat.com> writes:
 > 
 > > On Fri, Mar 08, 2013 at 07:16:09PM -0800, Linus Torvalds wrote:
 > >  > Goodie. Your bug reports gave me heartburn. But it sounds like we have an
 > >  > angle on all of the ones you've seen now?
 > >  > 
 > >  > Or have I forgotten about some case?
 > >  
 > > To be honest I've lost track of the whole collection.
 > > Let me repull your latest tree, and see what falls out.
 > > (I'll turn off CONFIG_USER_NS for now too until that gets fixed)
 > 
 > It was CONFIG_UTS_NS that tripped you.  
 > 
 > Since I can trigger this with /proc/self/ns/mnt/a you are going to be
 > able to compile this one out.

fwiw, the other namespace procfs files look like they have the same bug

I just triggered it again on /proc/571/task/571/ns/net

	Dave

