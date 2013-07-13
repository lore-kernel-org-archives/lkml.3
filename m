Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3GMA6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:58:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:11972 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957Ab3GMA6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:58:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,656,1367996400"; 
   d="scan'208";a="330686395"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] MinnowBoard Support V2 (Serial and Ethernet)
Date: Fri, 12 Jul 2013 17:58:04 -0700
Message-Id: <1373677087-7747-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the DMI interface to detect the board for UART_CLOCK selection
per Greg K-H.

Resend PCH_GBE_PHY_REGS_LEN define cleanup.

Rewrite of PCH_GBE MinnowBoard support to be completely independent from any
platform or board files. It requests the GPIO line in the pch_gbe driver and
minimizes the pch_gbe_privdata (PCI driver_data) structure.

Tested on 3.8, 3.10, and current master. Patches to lpc_sch and gpio_sch
required for 3.8, included in stable Cc lines.

