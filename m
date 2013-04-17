Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512Ab3DQTdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:33:43 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36781 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758061Ab3DQTdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:33:42 -0400
Date: Wed, 17 Apr 2013 12:33:42 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 3.9
Message-ID: <alpine.DEB.2.00.1304171231520.30041@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this final ceph fix for 3.9 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

It's a simple fix for a hard to hit race, but low-risk and clearly 
correct.

Thanks!
sage

----------------------------------------------------------------
Alex Elder (1):
      rbd: do a safe list traversal in rbd_img_request_submit()

 drivers/block/rbd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
