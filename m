Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428Ab3IUOv3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 10:51:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43315 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3IUOv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 10:51:27 -0400
Date: Sat, 21 Sep 2013 15:51:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH][RFC] Fix breakage in ffs_fs_mount()
Message-ID: <20130921145126.GT13318@ZenIV.linux.org.uk>
References: <20130920161421.GR13318@ZenIV.linux.org.uk>
 <xa1tsiwzytqf.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xa1tsiwzytqf.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 01:10:48AM +0200, Michal Nazarewicz wrote:
> On Fri, Sep 20 2013, Al Viro wrote:
> > 	There's a bunch of failure exits in ffs_fs_mount() with
> > seriously broken recovery logics.  Most of that appears to stem
> > from misunderstanding of the ->kill_sb() semantics;
> 
> That sounds likely.
> 
> [???]
> 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Umm...  Which tree should that go through?  I can put it in vfs.git, of
course, but it's local to drivers/usb/gadget, so a usb tree might be
a better fit...  It's -stable fodder, all way back to linux-3.3.y.
