Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3JLEvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:51:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:8640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab3JLEvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:51:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,480,1378882800"; 
   d="scan'208";a="391917615"
From: David Cohen <david.a.cohen@linux.intel.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: David Cohen <david.a.cohen@intel.com>
Subject: [PATCH 0/1] add maintainers for low-power Intel MID platform
Date: Fri, 11 Oct 2013 21:55:03 -0700
Message-Id: <1381553704-23321-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Cohen <david.a.cohen@intel.com>

Hi,

I'd like to add official maintainers for Intel MID platform on Linux kernel.
Current Intel MID support on upstream is outdated, but we've immediate plans to
update the code.
The 2 persons this patch is adding as maintainers are also part of Intel's
internal team responsible for it.

Please, consider to apply it.

This patch is meant to be merged just after renaming Moorestown code to generic
up-to-date Intel MID name on this patch set:
http://marc.info/?l=linux-kernel&m=138154934101936&w=2

Br, David Cohen
---

David Cohen (1):
  MAINTAINERS: INTEL MID SOC: add maintainers

 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
1.8.4.rc3

