Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaIXIAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:00:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:56794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbaIXIAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:00:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="604520616"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-usb@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [resend PATCH 0/3] usb: dwc3: ACPI support
Date: Wed, 24 Sep 2014 11:00:36 +0300
Message-Id: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The original series included patch that adds Braswell PCI ID, but I
send it separately.

The DMA mask caused a problem as our acpi platform code does not
provide anything for us. Instead of trying to fix it in dwc3 I
decided to suggest the first patch in this series where I provide
default DMA mask for all the ACPI platform devices.


Heikki Krogerus (3):
  ACPI / platform: provide default DMA mask
  usb: dwc3: core: only setting the dma_mask when needed
  usb: dwc3: add ACPI support

 drivers/acpi/acpi_platform.c |  2 ++
 drivers/usb/dwc3/core.c      | 18 +++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

-- 
2.1.0

