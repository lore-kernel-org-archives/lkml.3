Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaHOH0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:26:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34821 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbaHOH0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:26:43 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 11/14] powerpc/perf/hv-24x7: Documentaion for new sysfs entries which expose descriptions
Date: Fri, 15 Aug 2014 00:26:20 -0700
Message-Id: <1408087583-32239-12-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408087583-32239-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1408087583-32239-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081507-7182-0000-0000-000000359F9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <dev@codyps.com>

CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 .../testing/sysfs-bus-event_source-devices-hv_24x7 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7 b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
index e78ee79..5b501d7 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
@@ -21,3 +21,25 @@ Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
 Description:
 		Exposes the "version" field of the 24x7 catalog. This is also
 		extractable from the provided binary "catalog" sysfs entry.
+
+What:		/sys/bus/event_source/devices/hv_24x7/event_descs/<event-name>
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		Provides the description of a particular event as provided by
+		the firmware. If firmware does not provide a description, no
+		file will be created.
+
+		Note that the event-name lacks the domain suffix appended for
+		events in the events/ dir.
+
+What:		/sys/bus/event_source/devices/hv_24x7/event_long_descs/<event-name>
+Date:		February 2014
+Contact:	Cody P Schafer <cody@linux.vnet.ibm.com>
+Description:
+		Provides the "long" description of a particular event as
+		provided by the firmware. If firmware does not provide a
+		description, no file will be created.
+
+		Note that the event-name lacks the domain suffix appended for
+		events in the events/ dir.
-- 
1.8.3.1

