Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaIMOuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 10:50:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:4749 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751912AbaIMOuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 10:50:37 -0400
Message-Id: <20140913144906.020493245@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sat, 13 Sep 2014 10:49:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Clark Williams <williams@redhat.com>
Subject: [for-nex][PATCH 0/2] ftrace: Therapy updates
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


What? Me working? Um, no! This is just, um, my physical therapy. Yeah,
that's it. Part of my therapy is to stare at a monitor and randomly
raise and lower my fingers on top of a keyboard.

Alright, alright, you caught me  :-p  Please don't tell my wife!!!!

(me cleaning things up for more work to come, when I'm better)

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 3ddee63a099ebbdc8f84697fe46730b58240c09d


Steven Rostedt (Red Hat) (2):
      ftrace: Add sanity check when unregistering last ftrace_ops
      ftrace: Only disable ftrace_enabled to test buffer in selftest

----
 kernel/trace/ftrace.c         | 15 +++++++++++++++
 kernel/trace/trace_selftest.c |  4 ++++
 2 files changed, 19 insertions(+)
