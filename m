Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab3JQRgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:36:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3JQRgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:36:46 -0400
Date: Thu, 17 Oct 2013 10:36:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core fixes for 3.12-rc6
Message-ID: <20131017173645.GA8057@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.12-rc6

for you to fetch changes up to a37f86305c80f441b8b99dae7c19d3f9d2effc15:

  driver core: Release device_hotplug_lock when store_mem_state returns EINVAL (2013-10-16 18:42:41 -0700)

----------------------------------------------------------------
Driver core fix for 3.12-rc6

Here is one fix for the hotplug memory path that resolves a regression
when removing memory that showed up in 3.12-rc1.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Yasuaki Ishimatsu (1):
      driver core: Release device_hotplug_lock when store_mem_state returns EINVAL

 drivers/base/memory.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)
