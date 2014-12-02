Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaLBP3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:29:09 -0500
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:47913 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaLBP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:29:08 -0500
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
X-Google-Original-From: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        JBottomley@Parallels.com, Sathya.Prakash@avagotech.com,
        Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Subject: [PATCH 0/2] Revert mpt2sas, mpt3sas: remove disconnected phys on topology change
Date: Tue,  2 Dec 2014 20:58:45 +0530
Message-Id: <1417534127-6189-1-git-send-email-Sreekanth.Reddy@avagotech.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reverting the below commit IDs

1. [PATCH 1/2] mpt2sas: Remove phys on topology change
   commit ID: 3520f9c779bed098ca76dd3fb6377264301d57ed

2. [PATCH 2/2] mpt3sas: Remove phys on topology change
   commit ID: 963ba22b90a955363644cd397b20226928eab976

Sreekanth Reddy (2):
  Revert "[SCSI] mpt2sas: Remove phys on topology change."
  Revert "[SCSI] mpt3sas: Remove phys on topology change"

 drivers/scsi/mpt2sas/mpt2sas_transport.c | 5 +----
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

-- 
2.0.2

