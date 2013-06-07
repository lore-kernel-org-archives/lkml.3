Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3FGQLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:11:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:14344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab3FGQK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:10:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,822,1363158000"; 
   d="scan'208";a="346434952"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [GIT PULL] Some error injection fixes to queue for 3.11
Date: Fri, 07 Jun 2013 09:10:58 -0700
Message-Id: <51b20612239358173f@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-einj

for you to fetch changes up to ace3647afb3eca214f6da5d653ad116ff77545b6:

  ACPI/APEI: Update einj documentation for param1/param2 (2013-06-06 15:28:11 -0700)

----------------------------------------------------------------
Miscellaneous fixes for ACPI EINJ (error injection) code.

----------------------------------------------------------------
Chen Gong (2):
      ACPI/APEI: Add parameter check before error injection
      ACPI/APEI: Update einj documentation for param1/param2

Wei Yongjun (1):
      ACPI, APEI, EINJ: Fix error return code in einj_init()

 Documentation/acpi/apei/einj.txt |  9 +++++++--
 drivers/acpi/apei/einj.c         | 39 ++++++++++++++++++++++++++++++++++++---
 kernel/resource.c                |  1 +
 3 files changed, 44 insertions(+), 5 deletions(-)
