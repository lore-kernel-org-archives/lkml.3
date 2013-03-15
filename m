Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3COO6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 10:58:11 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:59692 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401Ab3COO6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 10:58:09 -0400
Message-ID: <1363359483.1335.110.camel@x61.thuisdomein>
Subject: [PATCH] Documentation: Remove text on tracepoint samples
From: Paul Bolle <pebolle@tiscali.nl>
To: Rob Landley <rob@landley.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 15 Mar 2013 15:58:03 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2013 14:58:04.0189 (UTC) FILETIME=[7ECE7CD0:01CE218D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracepoint sample code got removed. Remove a few lines on its usage
too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/trace/tracepoints.txt | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/Documentation/trace/tracepoints.txt b/Documentation/trace/tracepoints.txt
index c0e1cee..da49437 100644
--- a/Documentation/trace/tracepoints.txt
+++ b/Documentation/trace/tracepoints.txt
@@ -81,7 +81,6 @@ tracepoint_synchronize_unregister() must be called before the end of
 the module exit function to make sure there is no caller left using
 the probe. This, and the fact that preemption is disabled around the
 probe call, make sure that probe removal and module unload are safe.
-See the "Probe example" section below for a sample probe module.
 
 The tracepoint mechanism supports inserting multiple instances of the
 same tracepoint, but a single definition must be made of a given
@@ -100,17 +99,3 @@ core kernel image or in modules.
 If the tracepoint has to be used in kernel modules, an
 EXPORT_TRACEPOINT_SYMBOL_GPL() or EXPORT_TRACEPOINT_SYMBOL() can be
 used to export the defined tracepoints.
-
-* Probe / tracepoint example
-
-See the example provided in samples/tracepoints
-
-Compile them with your kernel.  They are built during 'make' (not
-'make modules') when CONFIG_SAMPLE_TRACEPOINTS=m.
-
-Run, as root :
-modprobe tracepoint-sample (insmod order is not important)
-modprobe tracepoint-probe-sample
-cat /proc/tracepoint-sample (returns an expected error)
-rmmod tracepoint-sample tracepoint-probe-sample
-dmesg
-- 
1.7.11.7

