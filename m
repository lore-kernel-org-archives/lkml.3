Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3CMLTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:19:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49264 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3CMLTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:19:48 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-77-514060d10395
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/6] perf util: Cleanup trace related files
Date: Wed, 13 Mar 2013 20:19:39 +0900
Message-Id: <1363173585-9754-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a couple of cleanups of util/trace-event-* files that inspired
by David Ahern's patchset. :) All look like leftovers from the old
port of trace-cmd codes.

Thanks,
Namhyung


Namhyung Kim (6):
  perf util: Remove unused trace_read_data function
  perf util: Remove unused struct definitions
  perf util: Remove unnecessary calc_data_size variable
  perf util: Remove unused macro definitions
  perf util: Remove duplicated page_size definition
  perf util: Change trace info output file name

 tools/perf/util/trace-event-info.c |  31 +-----
 tools/perf/util/trace-event-read.c | 201 -------------------------------------
 2 files changed, 1 insertion(+), 231 deletions(-)

-- 
1.7.11.7

