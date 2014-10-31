Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422845AbaJaCt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:49:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:24761 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422773AbaJaCt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:49:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,291,1413270000"; 
   d="scan'208";a="614496245"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 0/3] Rework "xhci: clear root port wake on bits if controller isn't wake-up capable"
Date: Fri, 31 Oct 2014 10:38:55 +0800
Message-Id: <1414723138-62776-1-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serie of patch reworks commit ff8cbf250b448aac35589f6075082c3fcad8a8fe.
This has been discussed at http://www.spinics.net/lists/linux-usb/msg114986.html
It also includes a patch to fix a comment in drivers/usb/host/xhci.h.

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

