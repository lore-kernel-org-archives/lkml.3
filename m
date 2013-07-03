Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab3GCQxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:53:23 -0400
Received: from longford.logfs.org ([213.229.74.203]:59728 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841Ab3GCQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:53:22 -0400
From: Joern Engel <joern@logfs.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 0/3] target: three cleanup patches
Date: Wed,  3 Jul 2013 11:22:14 -0400
Message-Id: <1372864937-32437-1-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These things caught my eye while debugging something else.  Nothing
too exciting.

Joern Engel (3):
  target: remove iscsit_find_cmd_from_itt_or_dump()
  target: remove unused codes from enum tcm_tmrsp_table
  target: make queue_tm_rsp() return void

 drivers/infiniband/ulp/srpt/ib_srpt.c        |   14 +++++---------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |    4 +---
 drivers/target/iscsi/iscsi_target.c          |    5 +----
 drivers/target/iscsi/iscsi_target_configfs.c |    3 +--
 drivers/target/iscsi/iscsi_target_util.c     |   24 ------------------------
 drivers/target/iscsi/iscsi_target_util.h     |    2 --
 drivers/target/loopback/tcm_loop.c           |    3 +--
 drivers/target/sbp/sbp_target.c              |    3 +--
 drivers/target/tcm_fc/tcm_fc.h               |    2 +-
 drivers/target/tcm_fc/tfc_cmd.c              |    8 ++------
 drivers/usb/gadget/tcm_usb_gadget.c          |    3 +--
 drivers/vhost/tcm_vhost.c                    |    3 +--
 include/target/target_core_base.h            |   13 +++++--------
 include/target/target_core_fabric.h          |    2 +-
 14 files changed, 21 insertions(+), 68 deletions(-)

-- 
1.7.10.4

