Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3GSXg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:36:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55520 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3GSXgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:36:16 -0400
Date: Sat, 20 Jul 2013 00:36:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with
 O_TMPFILE flag
Message-ID: <20130719233613.GH4165@ZenIV.linux.org.uk>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719121405.GA3856@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 08:14:05PM +0800, Zheng Liu wrote:
> Hi Dave,
> 
> After applied this patch, the problem has been fixed in my own sand box.
> But that would be great if you could give it a try.  I want to make sure
> that this patch can fix the problem.  It looks like there has the same
> problem in ext3.  So if this patch is fine, I will generate a patch for
> ext3 file system.

Nice catch, and you have my ACK.  Which tree do you prefer that to go
through?  vfs and ext4 are the obvious candidates...
