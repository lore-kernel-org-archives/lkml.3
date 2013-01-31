Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3AaFvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:51:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:47059 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab3AaFvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:51:47 -0500
Date: Thu, 31 Jan 2013 05:51:35 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org
Subject: [git pull] revert the console lockdep 
Message-ID: <alpine.DEB.2.00.1301310549230.7580@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

as suggested lets undo the console lock lockdep tracking for now,

Dave.

The following changes since commit 2e51b231a8d716ea5aacde0bd95ac789cea195b0:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-01-30 12:02:26 +1100)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to ff0d05bf73620eb7dc8aee7423e992ef87870bdf:

  Revert "console: implement lockdep support for console_lock" (2013-01-31 15:46:56 +1100)

----------------------------------------------------------------
Dave Airlie (1):
      Revert "console: implement lockdep support for console_lock"

 kernel/printk.c | 9 ---------
 1 file changed, 9 deletions(-)
