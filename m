Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbaGJFdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:33:13 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:54074
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaGJFdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:33:09 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/8] Drivers: scsi: storvsc: Bug fixes and improvements
Date: Wed,  9 Jul 2014 23:33:28 -0700
Message-Id: <1404974008-4984-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch set I have fixed a few bugs and implemented some enhancements.

In this version of the patch I have addressed comments from
Christoph Hellwig <hch@infradead.org>

K. Y. Srinivasan (8):
  Drivers: scsi: storvsc: Change the limits to reflect the values on
    the host
  Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supported by
    the Host
  Drivers: scsi: storvsc: Filter commands based on the storage protocol
    version
  Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
  Drivers: scsi: storvsc: Fix a bug in the handling of SRB status flags
  Drivers: scsi: storvsc: Implement an abort handler
  drivers: scsi: storvsc: Set srb_flags in all cases
  drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

 drivers/scsi/storvsc_drv.c |  128 ++++++++++++++++++++++++++++++++------------
 1 files changed, 93 insertions(+), 35 deletions(-)

-- 
1.7.4.1

