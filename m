Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaJAGED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:04:03 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44949 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaJAGD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:03:59 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 5/5] powerpc: Update contact info in Documentation files
Date: Tue, 30 Sep 2014 23:03:21 -0700
Message-Id: <1412143402-26061-6-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412143402-26061-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1412143402-26061-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100106-5806-0000-0000-000000A297C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cody's email address has changed. Update the contact information for
the 24x7 and GPCI counters to the PowerPC developers mailing list.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 .../ABI/testing/sysfs-bus-event_source-devices-hv_24x7       |  6 +++---
 .../ABI/testing/sysfs-bus-event_source-devices-hv_gpci       | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7 b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
index e78ee79..32f3f5f 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
@@ -1,6 +1,6 @@
 What:		/sys/bus/event_source/devices/hv_24x7/interface/catalog
 Date:		February 2014
-Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		Provides access to the binary "24x7 catalog" provided by the
 		hypervisor on POWER7 and 8 systems. This catalog lists events
@@ -10,14 +10,14 @@ Description:
 
 What:		/sys/bus/event_source/devices/hv_24x7/interface/catalog_length
 Date:		February 2014
-Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		A number equal to the length in bytes of the catalog. This is
 		also extractable from the provided binary "catalog" sysfs entry.
 
 What:		/sys/bus/event_source/devices/hv_24x7/interface/catalog_version
 Date:		February 2014
-Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		Exposes the "version" field of the 24x7 catalog. This is also
 		extractable from the provided binary "catalog" sysfs entry.
diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
index 3fa58c2..3ca4e55 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
@@ -1,6 +1,6 @@
 What:		/sys/bus/event_source/devices/hv_gpci/interface/collect_privileged
 Date:		February 2014
-Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		'0' if the hypervisor is configured to forbid access to event
 		counters being accumulated by other guests and to physical
@@ -9,35 +9,35 @@ Description:
 
 What:		/sys/bus/event_source/devices/hv_gpci/interface/ga
 Date:		February 2014
-Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		0 or 1. Indicates whether we have access to "GA" events (listed
 		in arch/powerpc/perf/hv-gpci.h).
 
 What:		/sys/bus/event_source/devices/hv_gpci/interface/expanded
 Date:		February 2014
-Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		0 or 1. Indicates whether we have access to "EXPANDED" events (listed
 		in arch/powerpc/perf/hv-gpci.h).
 
 What:		/sys/bus/event_source/devices/hv_gpci/interface/lab
 Date:		February 2014
-Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		0 or 1. Indicates whether we have access to "LAB" events (listed
 		in arch/powerpc/perf/hv-gpci.h).
 
 What:		/sys/bus/event_source/devices/hv_gpci/interface/version
 Date:		February 2014
-Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		A number indicating the version of the gpci interface that the
 		hypervisor reports supporting.
 
 What:		/sys/bus/event_source/devices/hv_gpci/interface/kernel_version
 Date:		February 2014
-Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		A number indicating the latest version of the gpci interface
 		that the kernel is aware of.
-- 
1.8.3.1

