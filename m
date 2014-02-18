Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaBRU7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:59:51 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33895 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaBRU7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:59:48 -0500
Subject: [PATCH v2 2/4] mei: Add include of <linux/irqreturn.h>
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: e1000-devel@lists.sourceforge.net, Joerg Roedel <joro@8bytes.org>,
        Sudeep Dutt <sudeep.dutt@intel.com>, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        iommu@lists.linux-foundation.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Aaron F Brown <aaron.f.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 18 Feb 2014 13:59:46 -0700
Message-ID: <20140218205946.11014.13654.stgit@bhelgaas-glaptop.roam.corp.google.com>
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
 drivers/misc/mei/hw-me.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 80bd829fbd9a..893d5119fa9b 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -20,6 +20,7 @@
 #define _MEI_INTERFACE_H_
 
 #include <linux/mei.h>
+#include <linux/irqreturn.h>
 #include "mei_dev.h"
 #include "client.h"
 

