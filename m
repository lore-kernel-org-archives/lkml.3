Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaBKCvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 21:51:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:15796 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbaBKCvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 21:51:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,822,1384329600"; 
   d="scan'208";a="481316917"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 0/2] ACPICA: Preparations of acpidump release automation.
Date: Tue, 11 Feb 2014 10:51:21 +0800
Message-Id: <cover.1392086457.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series includes required changes for acpidump release automation.

Since these commits actually are no-op for ACPICA and there are side
effects for Linux kernel after applying the linuxized ones, it is better to
post them in Linux community rather than in ACPICA community for review and
back port them to ACPICA upstream after merging them first into Linux.

Lv Zheng (2):
  ACPICA: acpidump: Add sparse declarators support.
  ACPICA: acpidump: Remove translation protection on integer types.

 include/acpi/actypes.h          |   64 +++++++++++++++++++--------------------
 include/acpi/platform/aclinux.h |   12 ++++++++
 2 files changed, 44 insertions(+), 32 deletions(-)

-- 
1.7.10

