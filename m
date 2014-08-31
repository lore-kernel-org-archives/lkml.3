Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaHaTAM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:00:12 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:45725 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaHaTAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:00:09 -0400
Message-ID: <1409511586.1483.5.camel@haakon3.risingtidesystems.com>
Subject: [GIT PULL] target updates for v3.17-rc3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 31 Aug 2014 11:59:46 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the target pending updates for v3.17-rc3.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Note that these patches where originally intended for -rc1, but missed
the merge window.  They are mostly iser-target related bug-fixes, along
with a few other very minor cleanups.

Thank you,

--nab

Andreea-Cristina Bernat (1):
  tcm_fc: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Himangi Saraogi (1):
  target/configfs: Remove unnecessary null test

Nicholas Bellinger (1):
  iscsi-target: Ignore ICF_GOT_LAST_DATAOUT during Data-Out ITT lookup

Rasmus Villemoes (1):
  target: target_core_ua_h: Add #define of include guard

Rickard Strandqvist (1):
  target: target_core_transport.c: Cleaning up missing null-terminate
    in conjunction with strncpy

Sagi Grimberg (4):
  Target/iser: Get isert_conn reference once got to connected_handler
  Target/iser: Don't put isert_conn inside disconnected handler
  Target/iser: Avoid calling rdma_disconnect twice
  Target/iser: Fix initiator_depth and responder_resources

 drivers/infiniband/ulp/isert/ib_isert.c      |   20 +++---
 drivers/target/iscsi/iscsi_target_util.c     |    2 +
 drivers/target/target_core_fabric_configfs.c |    3 +-
 drivers/target/target_core_transport.c       |   86 +++++++++++++-------------
 drivers/target/target_core_ua.h              |    1 +
 drivers/target/tcm_fc/tfc_sess.c             |    2 +-
 6 files changed, 60 insertions(+), 54 deletions(-)

