Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009Ab3JOEG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 00:06:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:56768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab3JOEGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 00:06:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,496,1378882800"; 
   d="scan'208";a="392987153"
From: Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
To: platform-driver-x86@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: [PATCH v2 0/3] IPC driver patches
Date: Mon, 14 Oct 2013 21:06:21 -0700
Message-Id: <cover.1381809435.git.sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches adds IPC support for addional intel platforms and adds
support for IPC command interrupt mode.

Please let me know your review comments.

Diff between v1 - v2 is,

- Updated the help content for CONFIG_INTEL_SCU_IPC_INTR_MODE and
  CONFIG_INTEL_SCU_IPC_POLL_MODE
- Updated the commit summary


Kuppuswamy Sathyanarayanan (3):
  ipc: Added platform data structure
  ipc: Enabled ipc support for additional intel platforms
  ipc: Added support for IPC interrupt mode

 drivers/platform/x86/Kconfig         |   23 +++++++
 drivers/platform/x86/intel_scu_ipc.c |  114 ++++++++++++++++++++++++++++++----
 2 files changed, 126 insertions(+), 11 deletions(-)

-- 
1.7.9.5

