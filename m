Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaHDKFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:05:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:21878 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaHDKFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:05:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,797,1400050800"; 
   d="scan'208";a="571380001"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: [PATCH] USB: pch_udc: Add support for Intel Quark X1000 USB gadget device
Date: Mon,  4 Aug 2014 11:00:07 -0700
Message-Id: <1407175207-23260-1-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alvin (Weike) Chen" <alvin.chen@intel.com>

Hi,
Intel Quark X1000 consists of one USB gadget device which can be PCI enumerated. 
pch_udc layer doesn't support it. Thus, we add support for Intel Quark X1000 USB
gadget device as well.

Bryan O'Donoghue (1):
  USB: pch_udc: USB gadget device support for Intel Quark X1000

 drivers/usb/gadget/udc/Kconfig   |    3 ++-
 drivers/usb/gadget/udc/pch_udc.c |   22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 4 deletions(-)

-- 
1.7.9.5

