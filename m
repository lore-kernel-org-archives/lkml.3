Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab3GWCjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:39:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:23708 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab3GWCje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:39:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,723,1367996400"; 
   d="scan'208";a="369445284"
From: Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
To: platform-driver-x86@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH v1 0/3] IPC driver patches
Date: Mon, 22 Jul 2013 19:48:42 -0700
Message-Id: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches adds IPC support for addional intel platforms and provides
default interrupt mode support.

Please let me know your review comments.

Kuppuswamy Sathyanarayanan (3):
  ipc: Added platform data structure
  ipc: Enabled ipc support for additional intel platforms
  ipc: Add support for default interrupt mode

 drivers/platform/x86/Kconfig         |   15 +++++
 drivers/platform/x86/intel_scu_ipc.c |  114 ++++++++++++++++++++++++++++++----
 2 files changed, 118 insertions(+), 11 deletions(-)

-- 
1.7.9.5

