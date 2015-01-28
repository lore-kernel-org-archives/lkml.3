Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbbA1U5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:57:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbbA1U5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:57:54 -0500
Date: Wed, 28 Jan 2015 10:55:23 -0800 (PST)
From: Sage Weil <sweil@redhat.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc7
Message-ID: <alpine.DEB.2.00.1501281052170.19195@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following two patches from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

These paches from Ilya finally squash a race condition with layered images 
that he's been chasing for a while.

Thanks!
sage

----------------------------------------------------------------
Ilya Dryomov (2):
      rbd: fix rbd_dev_parent_get() when parent_overlap == 0
      rbd: drop parent_ref in rbd_dev_unprobe() unconditionally

 drivers/block/rbd.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)
