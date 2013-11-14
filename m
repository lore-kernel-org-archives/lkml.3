Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab3KNWLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:11:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:63733 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab3KNWKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:10:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435469157"
From: David Cohen <david.a.cohen@linux.intel.com>
To: matthew.garrett@nebula.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, eric.ernst@linux.intel.com
Subject: [PATCH v2 0/4] Enable more Intel Mid platforms on IPC driver
Date: Thu, 14 Nov 2013 14:15:03 -0800
Message-Id: <1384467307-18556-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am resubmitting these patches to enable other Intel Mid platforms on IPC
driver.
This change is necessary prior to enable more features for Mid on upstream.

Changes from v1 to v2:
 - Fixed bug on patch 1/4: changed PCI_DEVICE to PCI_VDEVICE
 - Addressed Alan Cox'c comments:
   * Added log message for timeouts
   * Remove all #ifdefs from code

Br, David Cohen

---
Kuppuswamy Sathyanarayanan (4):
  ipc: Added platform data structure
  ipc: Enabled ipc support for additional intel platforms
  ipc: Handle error conditions in ipc command
  ipc: Added support for IPC interrupt mode

 drivers/platform/x86/intel_scu_ipc.c | 117 ++++++++++++++++++++++++++++++-----
 1 file changed, 103 insertions(+), 14 deletions(-)

-- 
1.8.4.2

