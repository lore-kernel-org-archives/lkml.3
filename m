Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3AXBPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 20:15:38 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:58250
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab3AXBPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 20:15:33 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, davem@davemloft.net, jkosina@suse.cz,
        James.Bottomley@HansenPartnership.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/6] Drivers: hv: Consolidate GUID definitions
Date: Wed, 23 Jan 2013 17:42:17 -0800
Message-Id: <1358991737-22675-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg suggested that it would be better to consolidate all the offer GUID
definitions in hyperv.h rather than having them defined in several files.
This patch-set does just that. Also, the shutdown code is executed in a thread
context.


K. Y. Srinivasan (6):
  Drivers: hv: vmbus: Consolidate all offer GUID definitions in
    hyperv.h
  Drivers: hv: Use consolidated GUID definitions
  Drivers: net: hyperv: Use the consolidated GUID definition
  Drivers: scsi: storvsc: Use the consolidated GUID definition
  Drivers: hid: hid-hyperv: Use consolidated GUID definitions
  Drivers: hv: Execute shutdown in a thread context

 drivers/hid/hid-hyperv.c        |    3 +-
 drivers/hv/channel_mgmt.c       |   31 +++----------
 drivers/hv/hv_balloon.c         |    4 +-
 drivers/hv/hv_util.c            |   36 +++++++++-----
 drivers/net/hyperv/netvsc_drv.c |    3 +-
 drivers/scsi/storvsc_drv.c      |   12 +++---
 include/linux/hyperv.h          |   94 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 132 insertions(+), 51 deletions(-)

-- 
1.7.4.1

