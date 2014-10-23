Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaJWIRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:17:50 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56515 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaJWIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:17:45 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: byungchul.park@lge.com
From: byungchul.park@lge.com
To: rostedt@goodmis.org, mingo@redhat.com
Cc: jolsa@redhat.com, vanilla@blackduck.lge.com, linux-kernel@vger.kernel.org,
        Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH 0/2] tracing, function_graph: signaling very large function execution time
Date: Thu, 23 Oct 2014 17:17:20 +0900
Message-Id: <1414052242-9828-1-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Byungchul Park <byungchul.park@lge.com>

Hello.

When I analysis the exit_mm() function to find out the reason why the
function spends much time occasionally, this patch was very useful.
I thought this patch cannot be useful only for me, but can be also
useful for anybody who want to be signaled for very large function
execution time, so I decided to submit this patchset.

Is there anybody who have such a demand? :)

Thanks,
Byungchul.

Byungchul Park (2):
  tracing, function_graph: fix micro seconds notation in comment
  tracing, function_graph: add additional marks to signal very large
    function execution time

 kernel/trace/trace_functions_graph.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

-- 
1.7.9.5

