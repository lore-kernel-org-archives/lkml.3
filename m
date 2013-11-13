Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab3KMUKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:10:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:28077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757855Ab3KMUKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:10:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="408334669"
From: David Cohen <david.a.cohen@linux.intel.com>
To: matthew.garrett@nebula.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.ernst@linux.intel.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 0/3] Enable more Intel Mid platforms on IPC driver
Date: Wed, 13 Nov 2013 12:14:28 -0800
Message-Id: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am resubmitting these patches to enable other Intel Mid platforms on IPC
driver.
This change is necessary prior to enable more features for Mid on upstream.

Br, David Cohen

---
Kuppuswamy Sathyanarayanan (3):
  ipc: Added platform data structure
  ipc: Enabled ipc support for additional intel platforms
  ipc: Added support for IPC interrupt mode

 drivers/platform/x86/Kconfig         |  23 +++++++
 drivers/platform/x86/intel_scu_ipc.c | 114 +++++++++++++++++++++++++++++++----
 2 files changed, 126 insertions(+), 11 deletions(-)

-- 
1.8.4.2

