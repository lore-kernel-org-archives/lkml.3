Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaFXNm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:42:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:50661 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaFXNm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:42:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,538,1400050800"; 
   d="scan'208";a="449324524"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 0/5] xhci fixes for 3.16-rc usb-linus
Date: Tue, 24 Jun 2014 16:54:14 +0300
Message-Id: <1403618059-24533-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

These xhci fixes are for usb-linus 3.16-rc.
Most of them are small fixes that also go to stable.
Julius "Correct last context entry" is the only one with a
bit more content.

-Mathias

Julius Werner (1):
  usb: xhci: Correct last context entry calculation for Configure
    Endpoint

Lu Baolu (1):
  xhci: clear root port wake on bits if controller isn't wake-up capable

Mathias Nyman (2):
  xhci: Use correct SLOT ID when handling a reset device command
  xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Wang, Yu (1):
  xhci: Fix runtime suspended xhci from blocking system suspend.

 drivers/usb/host/xhci-hub.c  |  5 +++-
 drivers/usb/host/xhci-ring.c |  9 ++++---
 drivers/usb/host/xhci.c      | 61 ++++++++++++++++++--------------------------
 3 files changed, 35 insertions(+), 40 deletions(-)

-- 
1.8.3.2

