Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaH2A0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 20:26:00 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37795
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaH2AZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 20:25:59 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com, decui@microsoft.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: hv: vmbus: Miscellaneous cleanup 
Date: Thu, 28 Aug 2014 18:29:33 -0700
Message-Id: <1409275773-28472-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup hv_post_message() to minimize failures. Also disable preemption
when sampling CPU ID when preemption is otherwise possible.

K. Y. Srinivasan (2):
  Drivers: hv: vmbus: Cleanup hv_post_message()
  Drivers: hv: vmbus: Properly protect calls to smp_processor_id()

 drivers/hv/channel.c      |    7 +++++--
 drivers/hv/channel_mgmt.c |   21 +++++++++++++++------
 drivers/hv/hv.c           |   28 ++++++++++++++++------------
 drivers/hv/hyperv_vmbus.h |    4 ++++
 4 files changed, 40 insertions(+), 20 deletions(-)

-- 
1.7.4.1

