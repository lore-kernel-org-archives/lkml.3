Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaBNVXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:23:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaBNVXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:23:53 -0500
Date: Fri, 14 Feb 2014 13:25:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core fix for 3.14-rc3
Message-ID: <20140214212513.GA19385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit da9846ae15186d491d6e21ebbb5051e1d3c7f652:

  kernfs: make kernfs_deactivate() honor KERNFS_LOCKDEP flag (2014-02-05 11:44:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.14-rc3

for you to fetch changes up to 9e1ccb4a7700fcb3ddfe2767e0bbb6131f8ab54e:

  drivers/base: fix devres handling for master device (2014-02-07 16:45:14 -0800)

----------------------------------------------------------------
Driver core fix for 3.14-rc3

Here is a single driver core patch for 3.14-rc3 for the component code that
Russell has found and fixed.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Russell King (1):
      drivers/base: fix devres handling for master device

 drivers/base/component.c | 8 ++++++++
 1 file changed, 8 insertions(+)
