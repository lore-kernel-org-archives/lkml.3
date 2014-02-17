Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaBQFAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:00:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:48065 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaBQFAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:00:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="476331699"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC Patch v1 0/6] Miscellaneous improvements for ACPI
Date: Mon, 17 Feb 2014 13:01:05 +0800
Message-Id: <1392613271-10912-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	This is a miscellaneous patch set to improve ACPI code. due to
resource limitation, I can't find hardware to test all patches.
So appreciate any help to these patches.

Thanks!
Gerry

Jiang Liu (6):
  acpi_pad: simplify notify handler by using acpi_drv_ops->notify
  ACPI: rename acpi_evaluate_hotplug_ost to acpi_evaluate_ost for reuse
  acpi_pad: use acpi_evaluate_pad() to replace open-coded version
  xen, acpi_pad: use acpi_evaluate_pad() to replace open-coded version
  acpi_processor: use acpi_evaluate_pad() to replace open-coded version
  ACPI: use device name LNXSYBUS.xx for ACPI \_SB and \_TZ objects

 drivers/acpi/acpi_pad.c          |   49 ++++++++------------------------------
 drivers/acpi/processor_perflib.c |   14 +++--------
 drivers/acpi/scan.c              |   20 ++++++++++++++--
 drivers/acpi/utils.c             |   14 ++++-------
 drivers/xen/xen-acpi-pad.c       |   26 ++++++--------------
 include/acpi/acpi_bus.h          |   10 +++++++-
 6 files changed, 51 insertions(+), 82 deletions(-)

-- 
1.7.10.4

