Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3KUAVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:21:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:24390 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab3KUAVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:21:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,740,1378882800"; 
   d="scan'208";a="431181538"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] NTB Update
Date: Wed, 20 Nov 2013 17:21:21 -0700
Message-Id: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are intended for inclusion in the 3.13 kernel.
They include a number of bug fixes, some cleanups, and a couple of
features.

Please let me know if there are any issues.  Otherwise, I'll send a pull
request to Linus on Friday for these patches.

Thanks,
Jon

---

Alexander Gordeev (1):
      ntb: Fix missed call to pci_enable_msix()

Jon Mason (7):
      NTB: Xeon Doorbell errata workaround
      NTB: Fix NTB-RP Link Up
      NTB: Fix ntb_transport link down race
      NTB: correct dmaengine_get/put usage
      NTB: Document HW errata
      NTB: Enable Snoop on Primary Side
      NTB: Disable interrupts and poll under high load

Michael Opdenacker (1):
      NTB: remove duplicate defines

