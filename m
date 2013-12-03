Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3LCI26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:28:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:15183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3LCI24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:28:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445878170"
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Convert ACPI fan driver to platform driver
Date: Tue,  3 Dec 2013 16:28:28 +0800
Message-Id: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset converts ACPI fan driver to platform driver. Patch 1-3 are
cleanups for existing fan driver and patch 4 does the convertion.

Tested on harris beach.
Apply on top of Rafael's linux-next branch.

Aaron Lu (4):
  ACPI / fan: remove unused macro for debug
  ACPI / fan: remove no need check for device pointer
  ACPI / fan: use acpi_device_xxx_power instead of acpi_bus equivelant
  ACPI / fan: convert to platform driver

 drivers/acpi/acpi_platform.c |  3 ++
 drivers/acpi/device_pm.c     |  1 +
 drivers/acpi/fan.c           | 88 ++++++++++++++++----------------------------
 drivers/acpi/internal.h      |  2 -
 include/acpi/acpi_bus.h      |  1 +
 5 files changed, 36 insertions(+), 59 deletions(-)

-- 
1.8.3.1

