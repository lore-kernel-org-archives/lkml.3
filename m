Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3I1TNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:13:13 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60718 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3I1TNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:13:11 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/7] perf trace enhancements
Date: Sat, 28 Sep 2013 13:12:57 -0600
Message-Id: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

Some more enhancements to perf-trace. It is based on your perf/trace
branch to keep the conflicts down based on the work you are doing.

David Ahern (7):
  perf util: Add machine method to loop over threads and invoke handler
  perf trace: Use new machine method to loop over threads
  perf trace: Fix comm resolution when reading events from file
  perf trace: Add record option
  perf util: Add priv variable to intlist
  perf util: Add findnew method to intlist
  perf trace: Add summary option to dump syscall statistics

 tools/perf/Documentation/perf-trace.txt |   16 ++-
 tools/perf/builtin-trace.c              |  237 +++++++++++++++++++++++++------
 tools/perf/util/intlist.c               |   11 ++
 tools/perf/util/intlist.h               |    2 +
 tools/perf/util/machine.c               |   23 +++
 tools/perf/util/machine.h               |    4 +
 6 files changed, 246 insertions(+), 47 deletions(-)

-- 
1.7.10.1

