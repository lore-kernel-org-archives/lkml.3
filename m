Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaA0Ebv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 23:31:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:20006 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbaA0Ebu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 23:31:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,727,1384329600"; 
   d="scan'208";a="471211653"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [PATCH v2] Thermal: ACPI INT3403 thermal driver
Date: Sun, 26 Jan 2014 20:31:40 -0800
Message-Id: <1390797101-3301-1-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2:
Updated description of CONFIG_ACPI_INT3403_THERMAL:

Linus didn't like the config help text. This patch updated the help text to
"
Newer laptops and tablets that use ACPI may have thermal sensors outside the
core CPU/SOC for thermal safety reasons. These temperature sensors are also
exposed for the OS to use via the so called INT3403 ACPI object. This driver
will, on devices that have such sensors, expose the temperature information
from these sensors to userspace via the normal thermal framework. This means
that a wide range of applications and GUI widgets can show this information to
the user or use this information for making decisions. For example, the Intel
Thermal Daemon can use this information to allow the user to select his laptop
to run without turning on the fans.
"

v1:
Base version reviewed and merged to linux-next

Srinivas Pandruvada (1):
  Thermal: ACPI INT3403 thermal driver

 drivers/thermal/Kconfig           |  15 +++
 drivers/thermal/Makefile          |   1 +
 drivers/thermal/int3403_thermal.c | 237 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 253 insertions(+)
 create mode 100644 drivers/thermal/int3403_thermal.c

-- 
1.8.3.2

