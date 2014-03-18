Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbaCROF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:05:58 -0400
Received: from mail.efficios.com ([78.47.125.74]:50254 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbaCROF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:05:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v5 0/3] Tracepoint API simplification/cleanup
Date: Tue, 18 Mar 2014 10:05:43 -0400
Message-Id: <1395151546-20445-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a respin of v5 of the tracepoint register/unregister API
simplification, along with the 2 other cleanup patches that comes
before.

Feedback is welcome,

Thanks!

Mathieu

Mathieu Desnoyers (3):
  Tracepoint cleanup: remove unused API functions
  Tracepoint API doc update: data argument
  Tracepoint: register/unregister struct tracepoint

 include/linux/ftrace_event.h |    1 +
 include/linux/tracepoint.h   |   62 ++--
 include/trace/ftrace.h       |    2 +
 kernel/trace/trace_events.c  |    8 +-
 kernel/tracepoint.c          |  707 ++++++++++++++----------------------------
 5 files changed, 268 insertions(+), 512 deletions(-)

-- 
1.7.10.4

