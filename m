Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3GCLhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:37:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3GCLhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:37:20 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=K2EtVE6aF4IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QwBj1TyaWVUA:10 a=ufEpn0uuRiRG3m28NHwA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703113635.696310819@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 07:36:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/8] tracing: Some more last minute fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


More fixes that need to go into linux-next before going mainline.

Still working on a fix for one more bug.

-- Steve

Steven Rostedt (Red Hat) (4):
      tracing: Add trace_array_get/put() to event handling
      tracing: Fix race between deleting buffer and setting events
      tracing: Make tracer_tracing_{off,on,is_on}() static
      tracing: Make tracing_open_generic_{tr,tc}() static

zhangwei(Jovi) (4):
      uprobes: Fix return value in error handling path
      tracing: Fix irqs-off tag display in syscall tracing
      tracing: Remove TRACE_EVENT_TYPE enum definition
      tracing: Remove ftrace() function

----
 kernel/trace/trace.c          |   19 +++-------
 kernel/trace/trace.h          |   14 ++------
 kernel/trace/trace_events.c   |   78 +++++++++++++++++++++++++++++++++++------
 kernel/trace/trace_syscalls.c |   21 ++++++++---
 kernel/trace/trace_uprobe.c   |    4 ++-
 5 files changed, 96 insertions(+), 40 deletions(-)
