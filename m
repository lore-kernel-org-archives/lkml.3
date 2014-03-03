Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaCCRVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:21:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:43453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaCCRVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:21:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,578,1389772800"; 
   d="scan'208";a="465619949"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 0/1] xhci: fixes for 3.14
Date: Mon,  3 Mar 2014 19:30:16 +0200
Message-Id: <1393867817-10389-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's a small xhci fix for 3.14 rc

Only one patch that prevents a panic on xhci_suspend() during xhci initialization
on some specific intel platforms if autosuspend is set to 0. 

We're already at rc5 and I'm not sure what is acceptable anymore at this stage in
the cycle.

-Mathias

Mathias Nyman (1):
  xhci: Prevent runtime pm from autosuspending during initialization

 drivers/usb/host/xhci-pci.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

-- 
1.8.1.2

