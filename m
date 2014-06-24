Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaFXH4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:56:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:14808 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaFXH4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:56:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,536,1400050800"; 
   d="scan'208";a="449200579"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: [PATCH] USB: ehci-pci: Add support for Intel Quark X1000 USB host controller
Date: Tue, 24 Jun 2014 08:51:42 -0700
Message-Id: <1403625103-28078-1-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alvin (Weike) Chen" <alvin.chen@intel.com>

Hi,
Intel Quark X1000 consists of one USB host controller which can be PCI enumerated.
But the exsiting EHCI-PCI framework doesn't support it. Thus, we enable it to support
Intel Quark X1000 USB host controller by adding pci quirks to configure buffer i/o threshold 
value to half.

Bryan O'Donoghue (1):
  Quark USB host

 drivers/usb/host/ehci-pci.c   |    4 ++++
 drivers/usb/host/pci-quirks.c |   42 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/pci-quirks.h |    2 ++
 3 files changed, 48 insertions(+)

-- 
1.7.9.5

