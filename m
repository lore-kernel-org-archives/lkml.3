Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3CAXsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 18:48:40 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39462 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3CAXsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 18:48:39 -0500
Date: Fri, 1 Mar 2013 15:48:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc patch for 3.9-rc1
Message-ID: <20130301234836.GA11405@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 09884964335e85e897876d17783c2ad33cf8a2e0:

  mm: do not grow the stack vma just because of an overrun on preceding vma (2013-02-27 08:36:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.9-rc1

for you to fetch changes up to 302a3c0f2757ae1a3e7df3f9fa1f20e2214ab945:

  Drivers: hv: vmbus: Use the new infrastructure for delivering VMBUS interrupts (2013-02-27 10:15:53 -0800)

----------------------------------------------------------------
Char/Misc remaining patch for 3.9-rc1

Here is one remaining patch for 3.9-rc1.  It is for the hyper-v drivers, and
had to wait until some other patches went in through the x86 tree.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Use the new infrastructure for delivering VMBUS interrupts

 drivers/hv/channel_mgmt.c |  2 +-
 drivers/hv/hv.c           |  5 ++---
 drivers/hv/vmbus_drv.c    | 11 +++++++----
 3 files changed, 10 insertions(+), 8 deletions(-)
