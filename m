Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbbARGm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 01:42:56 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49191 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbARGmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 01:42:54 -0500
From: Tina Johnson <tinajohnson.1234@gmail.com>
To: JBottomley@parallels.com
Cc: praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com,
        julia.lawall@lip6.fr, abhijit.mahajan@avagotech.com,
        nagalakshmi.nandigama@avagotech.com, MPT-FusionLinux.pdl@avagotech.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tina Johnson <tinajohnson.1234@gmail.com>
Subject: [PATCH 0/2] Added pci_mapping_error() call and related clean up
Date: Sun, 18 Jan 2015 12:11:01 +0530
Message-Id: <cover.1421489699.git.tinajohnson.1234@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced null test on dma handle with pci_dma_mapping_error() and cleaned 
up the error handling code.

Tina Johnson (2):
  drivers: scsi: mpt2sas: Added pci_dma_mapping_error() call
  drivers: scsi: mpt2sas: Clean up error handling for calls to pci_map_single

 drivers/scsi/mpt2sas/mpt2sas_transport.c |   35 +++++++++++++++---------------
 1 file changed, 17 insertions(+), 18 deletions(-)

-- 
1.7.10.4

