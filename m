Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaISQPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:15:17 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:36070 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770AbaISQPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:15:15 -0400
Date: Fri, 19 Sep 2014 20:15:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.debian@gmx.de>, Jan Kara <jack@suse.cz>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] fs: don't remove inotify watchers from alive inode-s (v2)
Message-ID: <20140919161511.GW16395@moon>
References: <1411141516-1918-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411141516-1918-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 07:45:16PM +0400, Andrey Vagin wrote:
> Currently watchers are removed in dentry_iput(), if n_link is zero.  But
> other detries can be linked with this inode.
> 
...
> 
> v2: generate IN_DELETE_SELF when the last link to the file is removed
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
