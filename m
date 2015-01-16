Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbbAPSfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:35:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbbAPSfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:35:01 -0500
Date: Fri, 16 Jan 2015 10:35:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core fix for 3.19-rc5
Message-ID: <20150116183500.GA28375@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.19-rc5

for you to fetch changes up to 72392ed0eb6fde96826cb9d66bd4f50a7ba61450:

  kernfs: Fix kernfs_name_compare (2015-01-09 15:51:08 -0800)

----------------------------------------------------------------
Driver core fixes for 3.19-rc5

Here is one kernfs fix for a reported issue for 3.19-rc5.

It has been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Rasmus Villemoes (1):
      kernfs: Fix kernfs_name_compare

 fs/kernfs/dir.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)
