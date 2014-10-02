Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaJBTo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:44:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaJBTo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:44:58 -0400
Date: Thu, 2 Oct 2014 12:44:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.debian@gmx.de>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s
 (v2)
Message-Id: <20141002124457.d1478b8aa91265e6ff171ab7@linux-foundation.org>
In-Reply-To: <20141002104552.GC19748@quack.suse.cz>
References: <1411141516-1918-1-git-send-email-avagin@openvz.org>
	<20140924105155.GA24411@quack.suse.cz>
	<20140924131947.bc083e7f34981bbf73a364f1@linux-foundation.org>
	<20140925083010.GA3096@quack.suse.cz>
	<20141002104552.GC19748@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2014 12:45:52 +0200 Jan Kara <jack@suse.cz> wrote:

> > With the patch you'll always have the second case. So without the patch you
> > don't receive some events if the file has at least 2 hardlinks and then
> > gets unlinked. I think the risk that some application relies on *not* getting
> > those events is pretty low (especially since in the common case of file
> > without hardlinks you will get all those events).
>   Ping Andrew? Do you still need more info or are you now OK to merge the
> patch?

Resend please, with a completed changelog.
