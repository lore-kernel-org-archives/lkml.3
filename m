Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3GUA4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 20:56:44 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39606 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab3GUA4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 20:56:42 -0400
Date: Sat, 20 Jul 2013 20:56:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with
 O_TMPFILE flag
Message-ID: <20130721005636.GA21484@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <20130719233613.GH4165@ZenIV.linux.org.uk>
 <20130720163737.GA8870@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130720163737.GA8870@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 12:37:37AM +0800, Zheng Liu wrote:
> 
> Now ext4 tree has not yet rebased against 3.11-rcX.  So it seems that
> vfs tree is better if we want to fix this bug in mainline kernel as soon
> as possible.

I was going to rebase the ext4 tree to Linus's current tree just to
get this patch in.  I think it would be good to get this fix before
-rc2, so either you or I should get this to Linus ASAP.

So Al, if you're going to send vfs patches to Linus this weekend (say,
to fix the equivalent bug for ext3), go for it.  Otherwise, let me
know and I'll send Linus a one-commit pull request just to get this
fix in.

Cheers,

						- Ted
