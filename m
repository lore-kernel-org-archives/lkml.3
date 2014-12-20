Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaLTCjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 21:39:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60537 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaLTCjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 21:39:19 -0500
Date: Sat, 20 Dec 2014 02:39:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs.git pile 3
Message-ID: <20141220023916.GZ22149@ZenIV.linux.org.uk>
References: <20141219165751.GY22149@ZenIV.linux.org.uk>
 <CA+55aFxah0iGacLruQ2j4V4JEGMkxLY0s5z67JP3XL1usijdhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxah0iGacLruQ2j4V4JEGMkxLY0s5z67JP3XL1usijdhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 06:19:02PM -0800, Linus Torvalds wrote:
> On Fri, Dec 19, 2014 at 8:57 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > Assorted fixes and patches from the last cycle.  There will be at least
> > one more pile this cycle, maybe two.
> 
> No there won't.
> 
> It's Friday evening before xmas, and the merge window is mostly over.
> Already, he merge window already has grown *huge* and seems to have
> more commits in it that linux-next ever did.
> 
> It's too late to say "one or two more piles".
> 
> Plan on fixes only from now on.

Er...  What about this one?  At least 4 commits in this branch are pure
bugfixes, 2 of them - for regressions introduced since 3.18...
