Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3CRIeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:34:16 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:55396 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab3CRIeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:34:13 -0400
Message-ID: <1363595650.1335.141.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Documentation: Remove text on tracepoint samples
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 18 Mar 2013 09:34:10 +0100
In-Reply-To: <1363359483.1335.110.camel@x61.thuisdomein>
References: <1363359483.1335.110.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2013 08:34:11.0081 (UTC) FILETIME=[5D3E5F90:01CE23B3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracepoint sample code got removed. Remove a few lines on its usage
too.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Rob Landley <rob@landley.net>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Rob asked (off list) to submit this for the trivial tree.

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

