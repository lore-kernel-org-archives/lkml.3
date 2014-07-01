Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbaGAHTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:19:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:62746 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaGAHTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:19:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,580,1400050800"; 
   d="scan'208";a="555665741"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: [PATCH v4] USB: ehci-pci: Add support for Intel Quark X1000 USB
Date: Tue,  1 Jul 2014 08:15:33 -0700
Message-Id: <1404227734-14825-1-git-send-email-alvin.chen@intel.com>
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

 drivers/usb/host/ehci-pci.c |   25 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

-- 
1.7.9.5

