Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbbA0Bnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:43:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46719 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314AbbA0Bni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:43:38 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: dev@codyps.com, peterz@infradead.org, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 7/7] powerpc/perf/hv-24x7: Document sysfs event description entries
Date: Mon, 26 Jan 2015 17:43:10 -0800
Message-Id: <1422322990-9030-8-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1422322990-9030-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012701-0037-0000-0000-00000076F1DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Changelog[v6]
	Update Contact info to Linux on Power Developer list

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 .../testing/sysfs-bus-event_source-devices-hv_24x7 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7 b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
index 32f3f5f..f893337 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
@@ -21,3 +21,25 @@ Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
 Description:
 		Exposes the "version" field of the 24x7 catalog. This is also
 		extractable from the provided binary "catalog" sysfs entry.
+
+What:		/sys/bus/event_source/devices/hv_24x7/event_descs/<event-name>
+Date:		February 2014
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
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
+Contact:	Linux on PowerPC Developer List <linuxppc-dev@lists.ozlabs.org>
+Description:
+		Provides the "long" description of a particular event as
+		provided by the firmware. If firmware does not provide a
+		description, no file will be created.
+
+		Note that the event-name lacks the domain suffix appended for
+		events in the events/ dir.
-- 
1.8.3.1

