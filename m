Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3JKBvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:51:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:28472 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab3JKBv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:51:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1076,1371106800"; 
   d="scan'208";a="306398285"
From: tianyu.lan@intel.com
To: tianyu.lan@intel.com, lenb@kernel.org, rjw@sisk.pl,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] ACPI: Remove unused files and directories under /proc/acpi
Date: Fri, 11 Oct 2013 09:51:18 +0800
Message-Id: <1381456283-22175-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is to remove AC/Battery directories and alarm file under /proc/acpi

drivers/acpi/Kconfig                                 |  17 --
drivers/acpi/Makefile                                |   1 -
drivers/acpi/ac.c                                    | 128 +--------
drivers/acpi/battery.c                               | 328 +---------------------
drivers/acpi/cm_sbs.c                                | 105 -------
drivers/acpi/proc.c                                  | 305 --------------------
drivers/acpi/sbs.c                                   | 325 +--------------------
9 files changed, 7 insertions(+), 1251 deletions(-)

[PATCH 1/5] ACPI/AC: Remove AC's proc directory.
[PATCH 2/5] ACPI/Battery: Remove battery's proc directory
[PATCH 3/5] ACPI/SBS: Remove SBS's proc directory
[PATCH 4/5] ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c
[PATCH 5/5] ACPI/Proc: Remove alarm proc file
