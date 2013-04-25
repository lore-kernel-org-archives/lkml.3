Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab3DYHwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:52:33 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:44523 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3DYHwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:52:30 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH/for-next 0/3] iscsi-target/iser-target: Fix breakage
Date: Thu, 25 Apr 2013 07:40:28 +0000
Message-Id: <1366875631-18795-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

This series addresses two bugs within v3.10 for-next code related to
the upcoming iscsi-target series adding multi-transport support, along
with a third iser-target bugfix related to early ISCSI_OP_SCSI_CMD
exception handling.

These three patches are being folded into for-next/for-next-merge code
now..

Thanks!

--nab

Nicholas Bellinger (3):
  iscsi-target: Fix solicited NopIN handling with RDMAExtentions=No
  iscsi-target: Fix iscsit_handle_scsi_cmd() exception se_cmd leak
  iser-target: Add special case for early ISCSI_OP_SCSI_CMD exception
    handling

 drivers/infiniband/ulp/isert/ib_isert.c |    7 ++++++
 drivers/target/iscsi/iscsi_target.c     |   32 ++++++++++++++++++------------
 2 files changed, 26 insertions(+), 13 deletions(-)

-- 
1.7.2.5

