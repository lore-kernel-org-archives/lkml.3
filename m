Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbbAJGlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 01:41:55 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56764
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbbAJGly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 01:41:54 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 0/6] Drivers: hv: Miscellaneous fixes and enhancements 
Date: Fri,  9 Jan 2015 23:54:00 -0800
Message-Id: <1420876440-9164-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to some miscellaneous bug fixes and enhancements
implement a clockevent device based on the functionality supported by Hyper-V.

K. Y. Srinivasan (6):
  Drivers: hv: hv_balloon: Make adjustments in computing the floor
  Drivers: hv: hv_balloon: Fix a locking bug in the balloon driver
  Drivers: hv: hv_balloon: Don't post pressure status from interrupt
    context
  Drivers: hv: vmbus: Implement a clockevent device
  Drivers: hv: vmbus: Fix a bug in vmbus_establish_gpadl()
  Drivers: hv: vmbus: Support a vmbus API for efficiently sending page
    arrays

 arch/x86/include/uapi/asm/hyperv.h |   11 +++++
 drivers/hv/channel.c               |   48 +++++++++++++++++++-
 drivers/hv/hv.c                    |   78 +++++++++++++++++++++++++++++++
 drivers/hv/hv_balloon.c            |   88 +++++++++++++++++++++++++++++-------
 drivers/hv/hyperv_vmbus.h          |   21 +++++++++
 drivers/hv/vmbus_drv.c             |   40 +++++++++++++++-
 include/linux/hyperv.h             |   31 +++++++++++++
 7 files changed, 297 insertions(+), 20 deletions(-)

-- 
1.7.4.1

