Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaKDIor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:44:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:12145 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaKDIoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:44:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="484326560"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 0/3] Rework "xhci: clear root port wake on bits if controller isn't wake-up capable"
Date: Tue,  4 Nov 2014 16:34:23 +0800
Message-Id: <1415090066-57007-1-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serie of patch reworks commit ff8cbf250b448aac35589f6075082c3fcad8a8fe.
This has been discussed at http://www.spinics.net/lists/linux-usb/msg114986.html
It also includes a patch to fix a comment in drivers/usb/host/xhci.h.

Changes in v2:
* Should not be a quirk.
* Should be applied to all xhci controllers.

Lu Baolu (3):
  usb: xhci: Revert "xhci: clear root port wake on bits if controller
    isn't wake-up capable"
  usb: xhci: This reworks ff8cbf250b448aac35589f6075082c3fcad8a8fe
  usb: xhci: fix comment for PORT_DEV_REMOVE

 drivers/usb/host/xhci-hub.c |  5 +----
 drivers/usb/host/xhci-pci.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci.h     |  8 +++++++-
 3 files changed, 50 insertions(+), 5 deletions(-)

-- 
1.9.1

