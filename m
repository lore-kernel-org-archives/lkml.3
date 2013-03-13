Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3CMFHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:07:37 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:56036 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3CMFHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:07:35 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/4] perf: remove unused functions
Date: Tue, 12 Mar 2013 23:07:24 -0600
Message-Id: <1363151248-16674-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

Going through my backlog of perf cleanup patches. These remove unused
functions and then makes a sole callee static.

David Ahern (4):
  perf: remove unused print_event function
  perf: remove unused print_trace_event function
  perf: remove unused perf_session__remove_thread
  perf: move machine__remove_thread and make static

 tools/perf/util/machine.c           |   22 ++++++++++-----------
 tools/perf/util/machine.h           |    1 -
 tools/perf/util/session.c           |   12 ------------
 tools/perf/util/session.h           |    1 -
 tools/perf/util/trace-event-parse.c |   37 -----------------------------------
 tools/perf/util/trace-event.h       |    4 ----
 6 files changed, 11 insertions(+), 66 deletions(-)

-- 
1.7.10.1

