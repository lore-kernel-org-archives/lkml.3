Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3ANFCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:02:49 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53119 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3ANFCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:02:48 -0500
Date: Sun, 13 Jan 2013 21:03:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 3.8-rc3
Message-ID: <20130114050337.GA8557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.8-rc3

for you to fetch changes up to f1688e0431d3a395388e70fe21da89ed0de0c323:

  debugfs: convert gid= argument from decimal, not octal (2013-01-11 05:56:01 -0800)

----------------------------------------------------------------
Driver core fixes for 3.8-rc3

Here are two patches for 3.8-rc3.

One removes the __dev* defines from init.h now that all usages of it are gone
from your tree.  The other fix is for debugfs's paramater that was using the
wrong base for the option.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dave Reisner (1):
      debugfs: convert gid= argument from decimal, not octal

Greg Kroah-Hartman (1):
      Remove __dev* markings from init.h

 fs/debugfs/inode.c   |  2 +-
 include/linux/init.h | 20 --------------------
 2 files changed, 1 insertion(+), 21 deletions(-)
