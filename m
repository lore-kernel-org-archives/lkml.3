Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaJIBLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 21:11:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:62655 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752777AbaJIBLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 21:11:05 -0400
Message-Id: <20141009011010.446507073@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 08 Oct 2014 21:10:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/2] tracing: Minor fixes to the start up tests 
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 0cd8f5614fbf8a598a0a47526ac7dc42ab2ba8cd


Peter Zijlstra (1):
      tracing: Robustify wait loop

Steven Rostedt (1):
      tracing: Clean up scheduling in trace_wakeup_test_thread()

----
 kernel/trace/trace_events.c   |  5 ++++-
 kernel/trace/trace_selftest.c | 47 +++++++++++++++++++++++++++----------------
 2 files changed, 34 insertions(+), 18 deletions(-)
