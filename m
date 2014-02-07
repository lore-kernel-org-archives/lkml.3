Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaBGWOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 17:14:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaBGWOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 17:14:52 -0500
Date: Fri, 7 Feb 2014 14:16:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core fix for 3.14-rc2
Message-ID: <20140207221602.GA28565@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.14-rc2

for you to fetch changes up to da9846ae15186d491d6e21ebbb5051e1d3c7f652:

  kernfs: make kernfs_deactivate() honor KERNFS_LOCKDEP flag (2014-02-05 11:44:04 -0800)

----------------------------------------------------------------
Driver core fix for 3.14-rc2

Here is a single kernfs fix to resolve a much-reported lockdep issue with the
removal of entries in sysfs.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Tejun Heo (1):
      kernfs: make kernfs_deactivate() honor KERNFS_LOCKDEP flag

 fs/kernfs/dir.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)
