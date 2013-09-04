Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835Ab3IDCmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:42:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55648 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761801Ab3IDCmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:42:32 -0400
Date: Wed, 4 Sep 2013 03:42:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Kent <raven@themaw.net>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        rui.xiang@huawei.com, autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] autofs4 - fix device ioctl mount lookup
Message-ID: <20130904024230.GH13318@ZenIV.linux.org.uk>
References: <20130904005456.5025.94309.stgit@perseus.fritz.box>
 <20130904010301.GE13318@ZenIV.linux.org.uk>
 <20130904020013.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwF+dqSMyGE+3LamM+qSDymieyReYB+RPb8fHTTmntgqw@mail.gmail.com>
 <20130904022617.GG13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904022617.GG13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 03:26:17AM +0100, Al Viro wrote:
> I've applied slightly modified variant of Jeff's "vfs: allow umount to handle
> mountpoints without revalidating them" (modified by just leaving the
> struct path filled with mountpoint and leaving the equivalent of follow_mount()
> to caller) to the local queue and I'm pretty sure that it's what we want
> here as well.

... and killed the modifications since the result ends up uglier for
caller(s) anyway.  Reapplied as-is.
