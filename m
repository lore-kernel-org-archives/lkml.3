Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3GTQhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:37:53 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36706 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3GTQhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:37:50 -0400
Date: Sun, 21 Jul 2013 00:37:37 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with
 O_TMPFILE flag
Message-ID: <20130720163737.GA8870@gmail.com>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <20130719233613.GH4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719233613.GH4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Sat, Jul 20, 2013 at 12:36:13AM +0100, Al Viro wrote:
> On Fri, Jul 19, 2013 at 08:14:05PM +0800, Zheng Liu wrote:
> > Hi Dave,
> > 
> > After applied this patch, the problem has been fixed in my own sand box.
> > But that would be great if you could give it a try.  I want to make sure
> > that this patch can fix the problem.  It looks like there has the same
> > problem in ext3.  So if this patch is fine, I will generate a patch for
> > ext3 file system.
> 
> Nice catch, and you have my ACK.  Which tree do you prefer that to go
> through?  vfs and ext4 are the obvious candidates...

Now ext4 tree has not yet rebased against 3.11-rcX.  So it seems that
vfs tree is better if we want to fix this bug in mainline kernel as soon
as possible.  This patch is against mainline kernel.  I think it should
be applied into vfs tree cleanly.  Please let me know if I need to rebase
it against vfs tree.  BTW, the patch for ext3 file system will be sent
out soon.  Please pick it up.

Thanks,
                                                - Zheng
