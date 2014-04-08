Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaDHCAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:00:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:26266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbaDHB7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:59:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="488940297"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] NTB Update
Date: Mon,  7 Apr 2014 17:52:45 -0700
Message-Id: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches are intended for inclusion in the 3.15 kernel.
They include a number of bug fixes, some cleanups, and the conversion
to pci_enable_msix_range.

Please let me know if there are any issues.

Thanks,
Jon

---

Alexander Gordeev (4):
      ntb: Fix leakage of ntb_device::msix_entries[] array
      ntb: Use pci_msix_vec_count() to obtain number of MSI-Xs
      ntb: Split ntb_setup_msix() into separate BWD/SNB routines
      ntb: Use pci_enable_msix_range() instead of pci_enable_msix()

Jon Mason (4):
      ntb_netdev: Fix list_for_each_entry exit issue
      ntb_netdev: Fix skb free issue in open
      NTB: client event cleanup
      NTB: Code Style Clean-up

Roland Dreier (1):
      NTB: Fix typo in setting one translation register
