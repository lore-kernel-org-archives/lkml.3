Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaLSMgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 07:36:36 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41941 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaLSMge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:36:34 -0500
Date: Fri, 19 Dec 2014 13:36:32 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: joe@perches.com
Cc: 1 Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Minor clean up in mpt2sas
Message-ID: <20141219123632.GA20256@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The version 2 of this patch fix the logic error pointed out by Joe Perches.

Quentin Lambert (3):
  [SCSI] mpt2sas: Merge two similar functions
  [SCSI] mpt2sas: Simplify the code of mpt2sas_scsih_tm_flag
  [SCSI] mpt2sas: Remove unnecessary use of a boolean variable

 drivers/scsi/mpt2sas/mpt2sas_base.c  |  6 +----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 48 +++++++-----------------------------
 2 files changed, 10 insertions(+), 44 deletions(-)

-- 
1.9.1

