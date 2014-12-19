Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaLSLKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:10:13 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36619 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaLSLKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:10:11 -0500
Date: Fri, 19 Dec 2014 12:10:08 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3]  Minor clean up in mpt2sas
Message-ID: <20141219111008.GA17968@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch merges two similar functions. Since the resulting
function is only called three times, it adds a parameter to differenciate
between the two behaviours.

The second patch proposes a simplification of the function code. The function
previously used a variable to skip through the rest of the loop. It now
uses a break statement to exit it.

The third patch simplifies an unnecesary complicated use of a boolean variable.

Quentin Lambert (3):
  [SCSI] mpt2sas: Merge two similar functions
  [SCSI] mpt2sas: Simplify the code of mpt2sas_scsih_tm_flag
  [SCSI] mpt2sas: Remove unnecessary use of a boolean variable

 drivers/scsi/mpt2sas/mpt2sas_base.c  |  6 +----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 48 +++++++-----------------------------
 2 files changed, 10 insertions(+), 44 deletions(-)

-- 
1.9.1

