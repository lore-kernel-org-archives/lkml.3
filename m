Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaGLPw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 11:52:58 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:44639
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaGLPw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 11:52:56 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: jasowang@redhat.com, apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V3 0/7] Drivers: scsi: storvsc: Bug fixes and improvements
Date: Sat, 12 Jul 2014 09:48:04 -0700
Message-Id: <1405183684-23928-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch set I have fixed a few bugs and implemented some enhancements.

In this version of the patch I have addressed comments from
Christoph Hellwig <hch@infradead.org>

K. Y. Srinivasan (7):
  Drivers: scsi: storvsc: Change the limits to reflect the values on
    the host
  Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supported by
    the Host
  Drivers: scsi: storvsc: Filter commands based on the storage protocol
    version
  Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
  Drivers: scsi: storvsc: Implement a timedout handler
  drivers: scsi: storvsc: Set srb_flags in all cases
  drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

 drivers/scsi/storvsc_drv.c |  111 ++++++++++++++++++++++++++++++-------------
 1 files changed, 77 insertions(+), 34 deletions(-)

-- 
1.7.4.1

