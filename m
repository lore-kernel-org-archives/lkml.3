Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaIXUTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:19:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaIXUTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:19:49 -0400
Date: Wed, 24 Sep 2014 13:19:47 -0700
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
Message-Id: <20140924131947.bc083e7f34981bbf73a364f1@linux-foundation.org>
In-Reply-To: <20140924105155.GA24411@quack.suse.cz>
References: <1411141516-1918-1-git-send-email-avagin@openvz.org>
	<20140924105155.GA24411@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 12:51:55 +0200 Jan Kara <jack@suse.cz> wrote:

>   Hello,
> 
>   Andrew, what do you think about the patch below? Al objected that it
> changes userspace visible behavior some time ago and then he didn't react
> to our explanations...

Difficult situation.  There's some really important information missing
from the changelog:

- Who cares?  Is there some real application which is hurting from
  the current situation?  If so, who, what, how and why.  If not, then
  why change anything?

- A description of the userspace API change impact.  How did the
  interface change?  What is the risk of this change causing damage to
  real applications?

If we can answer these questions then we're in a position to make the
pain-versus-gain tradeoff decision.

