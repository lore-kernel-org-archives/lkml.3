Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3FGW2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:28:51 -0400
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:52094 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753181Ab3FGW2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:28:49 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri,  7 Jun 2013 15:28:39 -0700
Message-Id: <1370644119-15200-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

InfiniBand fixes for 3.10-rc:
 - qib RCU/lockdep fix
 - iser device removal fix, plus doc fixes

----------------------------------------------------------------
Mike Marciniszyn (1):
      IB/qib: Fix lockdep splat in qib_alloc_lkey()

Or Gerlitz (2):
      IB/iser: Add Mellanox copyright
      MAINTAINERS: Add entry for iSCSI Extensions for RDMA (iSER) initiator

Roi Dayan (1):
      IB/iser: Fix device removal flow

Roland Dreier (1):
      Merge branches 'iser' and 'qib' into for-next

 MAINTAINERS                                  | 10 ++++++++++
 drivers/infiniband/hw/qib/qib_keys.c         |  2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  1 +
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  1 +
 drivers/infiniband/ulp/iser/iser_initiator.c |  1 +
 drivers/infiniband/ulp/iser/iser_memory.c    |  1 +
 drivers/infiniband/ulp/iser/iser_verbs.c     | 16 +++++++++-------
 7 files changed, 24 insertions(+), 8 deletions(-)
