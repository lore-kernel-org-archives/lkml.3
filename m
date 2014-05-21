Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaEUEv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:51:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaEUEv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:51:27 -0400
Date: Wed, 21 May 2014 13:51:16 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Driver core / sysfs fixes for 3.15-rc6
Message-ID: <20140521045116.GA11184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ driver-core-3.15-rc6

for you to fetch changes up to f5c16f29bf5e57ba4051fc7785ba7f035f798c71:

  sysfs: make sure read buffer is zeroed (2014-05-20 10:15:53 +0900)

----------------------------------------------------------------
Driver core fixes for 3.15-rc6

Here are two driver core (well, sysfs) fixes for 3.15-rc6 that resolve
some reported issues and a regression from 3.13.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Tejun Heo (2):
      kernfs, sysfs, cgroup: restrict extra perm check on open to sysfs
      sysfs: make sure read buffer is zeroed

 fs/kernfs/file.c       | 17 ++++++++++-------
 fs/sysfs/file.c        |  3 ++-
 fs/sysfs/mount.c       |  3 ++-
 include/linux/kernfs.h | 19 ++++++++++++++++++-
 4 files changed, 32 insertions(+), 10 deletions(-)
