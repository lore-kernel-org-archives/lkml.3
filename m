Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab3BGBWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:22:19 -0500
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:49702 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757758Ab3BGBWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:22:18 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2013 20:22:18 EST
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Wed,  6 Feb 2013 17:15:38 -0800
Message-Id: <1360199738-13948-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

IB regression fixes for 3.8:
 - Fix mlx4 VFs not working on old guests because of 64B CQE changes
 - Fix ill-considered sparse fix for qib
 - Fix IPoIB crash due to skb double destruct introduced in 3.8-rc1

----------------------------------------------------------------
Mike Marciniszyn (1):
      IB/qib: Fix for broken sparse warning fix

Or Gerlitz (1):
      mlx4_core: Fix advertisement of wrong PF context behaviour

Roland Dreier (1):
      Merge branches 'ipoib', 'mlx4' and 'qib' into for-next

Shlomo Pongratz (1):
      IPoIB: Fix crash due to skb double destruct

 drivers/infiniband/hw/qib/qib_qp.c        | 11 +++--------
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  6 +++---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |  6 +++---
 drivers/net/ethernet/mellanox/mlx4/main.c |  2 +-
 4 files changed, 10 insertions(+), 15 deletions(-)
