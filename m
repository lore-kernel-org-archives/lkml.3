Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaDKUve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:51:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:25642 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaDKUuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:50:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,843,1389772800"; 
   d="scan'208";a="491550248"
From: David Cohen <david.a.cohen@linux.intel.com>
To: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, david.a.cohen@linux.intel.com
Subject: [PATCH v2 0/2] Initial implementation of Intel MID watchdog driver
Date: Fri, 11 Apr 2014 13:50:05 -0700
Message-Id: <1397249407-5417-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set is an initial implementation of a generic Intel MID watchdog
driver.
It currently supports Intel Merrifield only, but will extend to other SoCs of
MID family.

changes from v1 to v2:
 - Fixed Kconfig entry as per Guenter Roeck suggestion

Br, David

--
David Cohen (2):
  watchdog: add Intel MID watchdog driver support
  x86: intel-mid: add watchdog platform code for Merrifield

 arch/x86/platform/intel-mid/device_libs/Makefile   |   1 +
 .../platform/intel-mid/device_libs/platform_wdt.c  |  43 +++++
 drivers/watchdog/Kconfig                           |  13 ++
 drivers/watchdog/Makefile                          |   1 +
 drivers/watchdog/intel-mid_wdt.c                   | 209 +++++++++++++++++++++
 5 files changed, 267 insertions(+)
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_wdt.c
 create mode 100644 drivers/watchdog/intel-mid_wdt.c

-- 
1.9.1

