Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaGHXqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:46:13 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:55686
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaGHXqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:46:11 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/8] Drivers: scsi: storvsc: Bug fixes and improvements 
Date: Tue,  8 Jul 2014 17:46:29 -0700
Message-Id: <1404866789-26910-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch set I have fixed a few bugs and implemented some enhancements.


K. Y. Srinivasan (8):
  Drivers: scsi: storvsc: Change the limits to reflect the values on
    the host
  Drivers: scsi: storvsc: Filter commands based on the storage protocol
    version
  Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
  Drivers: scsi: storvsc: Filter WRITE_SAME_16
  Drivers: scsi: storvsc: Fix a bug in the handling of SRB status flags
  Drivers: scsi: storvsc: Implement an abort handler
  drivers: scsi: storvsc: Set srb_flags in all cases
  drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

 drivers/scsi/storvsc_drv.c |  125 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 93 insertions(+), 32 deletions(-)

-- 
1.7.4.1

