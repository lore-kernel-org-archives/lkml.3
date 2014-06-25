Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbaFYRZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:25:20 -0400
Received: from cobra.newdream.net ([66.33.216.30]:56902 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbaFYRZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:25:19 -0400
Date: Wed, 25 Jun 2014 10:25:18 -0700 (PDT)
From: Sage Weil <sage@redhat.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for -rc4
Message-ID: <alpine.DEB.2.00.1406251019260.12946@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following patch for Ceph from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This fixes a corner case for cloned RBD images.

Thanks!
sage

----------------------------------------------------------------
Ilya Dryomov (1):
      rbd: handle parent_overlap on writes correctly

 drivers/block/rbd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)
