Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3JVRWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:22:38 -0400
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:39869 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753392Ab3JVRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:22:36 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 22 Oct 2013 10:22:28 -0700
Message-Id: <1382462548-14371-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the "disable ABI we don't want to freeze" pull I warned you about.

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
Disable not-quite-ready userspace ABI for IB flow steering

----------------------------------------------------------------
Yann Droneaud (1):
      IB/core: Temporarily disable create_flow/destroy_flow uverbs

 drivers/infiniband/Kconfig            | 11 +++++++++++
 drivers/infiniband/core/uverbs.h      |  2 ++
 drivers/infiniband/core/uverbs_cmd.c  |  4 ++++
 drivers/infiniband/core/uverbs_main.c |  6 ++++++
 drivers/infiniband/hw/mlx4/main.c     |  2 ++
 include/uapi/rdma/ib_user_verbs.h     |  6 ++++++
 6 files changed, 31 insertions(+)
