Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936078Ab3DJKXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:23:46 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:43293 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3DJKXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:23:44 -0400
From: Hanjun Guo <guohanjun@huawei.com>
To: <kernel.openeuler@huawei.com>
CC: Toshi Kani <toshi.kani@hp.com>, Jiang Liu <jiang.liu@huawei.com>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] ACPI and PM patches for Euler stable from mainline v3.6
Date: Wed, 10 Apr 2013 18:22:57 +0800
Message-ID: <1365589381-5624-1-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.10.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.124]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zefan,

These four patches are bugfix for ACPI and power management from mainline 
v3.6, comments are welcomed!

Thanks
Hanjun Guo


Colin Cross (1):
  cpuidle: fix error handling in __cpuidle_register_device

Stephen Boyd (1):
  cpufreq: Fix sysfs deadlock with concurrent hotplug/frequency switch

Thomas Renninger (2):
  ACPI: Untangle a return statement for better readability
  ACPI: Only count valid srat memory structures

 arch/ia64/kernel/acpi.c   |    5 +++--
 arch/x86/mm/srat.c        |   16 +++++++++-------
 drivers/acpi/numa.c       |   12 ++++++++----
 drivers/cpufreq/cpufreq.c |   35 +++++++++++++++++++++++++++--------
 drivers/cpuidle/cpuidle.c |   13 +++++++++----
 include/linux/acpi.h      |    2 +-
 6 files changed, 57 insertions(+), 26 deletions(-)


