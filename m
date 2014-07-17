Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaGQTjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:39:55 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:40974 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaGQTjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:39:53 -0400
Subject: [PATCH 0/3] blk-mq: blk_mq_init_rq_map error handling
To: axboe@kernel.dk, abhijit.mahajan@avagotech.com, kmo@datarainc.com,
        nagalakshmi.nandigama@avagotech.com, asamymuthupa@micron.com,
        snitzer@redhat.com, JBottomley@parallels.com,
        relliott@beardog.cce.hp.com, sreekanth.reddy@avagotech.com,
        praveen.krishnamoorthy@avagotech.com, agordeev@redhat.com,
        scameron@beardog.cce.hp.com, tom.leiming@gmail.com, elliott@hp.com,
        sbradshaw@micron.com, hch@lst.de, m@bjorling.me
From: Robert Elliott <elliott@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Thu, 17 Jul 2014 14:38:58 -0500
Message-ID: <20140717193707.1924.87867.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series cleans up blk_mq_init_rq_map failures
properly.

---

Robert Elliott (3):
      blk-mq: cleanup after blk_mq_init_rq_map failures
      blk-mq: pass along blk_mq_alloc_tag_set return values
      mpt3sas,mpt2sas: fix scsi_add_host error handling problems in _scsih_probe


 block/blk-mq.c                       |    3 +++
 drivers/block/mtip32xx/mtip32xx.c    |    1 -
 drivers/block/null_blk.c             |   29 +++++++++++++++++++++--------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    8 ++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    9 ++++++---
 5 files changed, 36 insertions(+), 14 deletions(-)

-- 
Rob Elliott, HP Server Storage
