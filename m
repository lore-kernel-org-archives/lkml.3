Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaBRU7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:59:46 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52155 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBRU7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:59:41 -0500
Subject: [PATCH v2 1/4] misc: mic: Add include of <linux/irqreturn.h>
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: e1000-devel@lists.sourceforge.net, Joerg Roedel <joro@8bytes.org>,
        Sudeep Dutt <sudeep.dutt@intel.com>, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        iommu@lists.linux-foundation.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Aaron F Brown <aaron.f.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 18 Feb 2014 13:59:39 -0700
Message-ID: <20140218205939.11014.41761.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140218205925.11014.14973.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140218205925.11014.14973.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently include <linux/irqreturn.h> in <linux/pci.h>, but I'm about to
remove that from linux/pci.h, so add explicit includes where needed.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/misc/mic/card/mic_device.h |    1 +
 drivers/misc/mic/host/mic_device.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/mic/card/mic_device.h b/drivers/misc/mic/card/mic_device.h
index 347b9b3b7916..306f502be95e 100644
--- a/drivers/misc/mic/card/mic_device.h
+++ b/drivers/misc/mic/card/mic_device.h
@@ -29,6 +29,7 @@
 
 #include <linux/workqueue.h>
 #include <linux/io.h>
+#include <linux/irqreturn.h>
 
 /**
  * struct mic_intr_info - Contains h/w specific interrupt sources info
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
index 1a6edce2ecde..0398c696d257 100644
--- a/drivers/misc/mic/host/mic_device.h
+++ b/drivers/misc/mic/host/mic_device.h
@@ -24,6 +24,7 @@
 #include <linux/cdev.h>
 #include <linux/idr.h>
 #include <linux/notifier.h>
+#include <linux/irqreturn.h>
 
 #include "mic_intr.h"
 

