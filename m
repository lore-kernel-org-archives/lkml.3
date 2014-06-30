Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaF3JIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:08:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:16866 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbaF3JIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="555173314"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jingoo Han <jg1.han@samsung.com>, David Laight <David.Laight@ACULAB.COM>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: [PATCH v3] USB: ehci-pci: Add support for Intel Quark X1000 USB
Date: Mon, 30 Jun 2014 10:05:59 -0700
Message-Id: <1404147960-17596-1-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alvin (Weike) Chen" <alvin.chen@intel.com>

Hi,
Intel Quark X1000 consists of one USB host controller which can be PCI
enumerated. And the exsiting EHCI-PCI framework supports it with the 
default packet buffer in/out threshold. We reconfigure the in/out threshold
as maximal as possible to maximize the performance.

Bryan O'Donoghue (1):
  USB: ehci-pci: USB host controller support for Intel Quark X1000

 drivers/usb/host/ehci-pci.c |   40 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

-- 
1.7.9.5

