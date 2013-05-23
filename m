Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab3EWS1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:27:50 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47350
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758066Ab3EWS1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:27:49 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/2] Drivers: hv: vmbus: Implement multi-channel support 
Date: Thu, 23 May 2013 12:02:10 -0700
Message-Id: <1369335730-16965-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set implements multi-channel support for Hyper-V devices.

Earlier, these two patches were sent out as part of a larger patch-set
that included relevant changes in the storage driver. 

In this version of the patch, I have fixed a race condition in the code that
opens the sub-channels.

K. Y. Srinivasan (2):
  Drivers: hv: vmbus: Implement multi-channel support
  Drivers: hv: Add the GUID fot synthetic fibre channel device

 drivers/hv/channel.c      |   50 +++++++++++++++++--
 drivers/hv/channel_mgmt.c |  119 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/hv/connection.c   |   14 +++++
 include/linux/hyperv.h    |   70 ++++++++++++++++++++++++++
 4 files changed, 245 insertions(+), 8 deletions(-)

-- 
1.7.4.1

