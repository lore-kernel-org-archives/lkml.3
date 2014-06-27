Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaF0D1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:27:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:43769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaF0D1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:27:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,558,1400050800"; 
   d="scan'208";a="450586219"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: [PATCH v2] USB: ehci-pci: Add support for Intel Quark X1000 USB host controller
Date: Fri, 27 Jun 2014 04:24:35 -0700
Message-Id: <1403868276-12558-1-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alvin (Weike) Chen" <alvin.chen@intel.com>

Hi,
Intel Quark X1000 consists of one USB host controller which can be PCI enumerated.
And the exsiting EHCI-PCI framework supports it with the default packet buffer in/out
threshold. We reconfigure the in/out threshold as maximal as possible.

Bryan O'Donoghue (1):
  USB: ehci-pci: USB host controller support for Intel Quark X1000

 drivers/usb/host/ehci-pci.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

-- 
1.7.9.5

