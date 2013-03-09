Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab3CIDZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:25:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933359Ab3CIDZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:25:34 -0500
Date: Fri, 8 Mar 2013 22:25:30 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130309032530.GA19839@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <CA+55aFyfOKXVpn41F_OPE7+CeNyN2ZhwPeEJ8bkZLxBEkz31sg@mail.gmail.com>
 <20130309001917.GA6015@redhat.com>
 <20130309003617.GB6743@redhat.com>
 <CA+55aFzS0MpqRNM_HmJq6GKiuBncieA6LysNjSM1qSmETitkGw@mail.gmail.com>
 <20130309020318.GA11449@redhat.com>
 <CA+55aFwoqQUgS3ou4oqA-G7-cQzU-pwq7aSJ9vA5oyWCshhDkw@mail.gmail.com>
 <20130309022623.GB11449@redhat.com>
 <20130309025631.GA13188@redhat.com>
 <20130309025752.GA13913@redhat.com>
 <CA+55aFxyOYXnzDoWr7Utr1QLjjMUCON5EGH3FMvGBHxnxMJmQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxyOYXnzDoWr7Utr1QLjjMUCON5EGH3FMvGBHxnxMJmQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 07:16:09PM -0800, Linus Torvalds wrote:
 > Goodie. Your bug reports gave me heartburn. But it sounds like we have an
 > angle on all of the ones you've seen now?
 > 
 > Or have I forgotten about some case?
 
To be honest I've lost track of the whole collection.
Let me repull your latest tree, and see what falls out.
(I'll turn off CONFIG_USER_NS for now too until that gets fixed)

I have a feeling there were some sysfs ones that may still be unfixed.

	Dave

