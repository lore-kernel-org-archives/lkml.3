Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3JID1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:27:06 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45189 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3JID1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:27:03 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3] perf trace enhancements
Date: Tue,  8 Oct 2013 21:26:51 -0600
Message-Id: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

Revision to intlist per your comment with the summary option
updated per your perf/core branch.

The mmap output file has survived local testing without problems
so please consider it for inclusion as well. It lowers the overhead
of perf-record.

David Ahern (3):
  perf util: Add findnew method to intlist - v2
  perf trace: Add summary option to dump syscall statistics
  perf record: mmap output file

 tools/perf/Documentation/perf-trace.txt |    4 ++
 tools/perf/builtin-record.c             |   87 ++++++++++++++++++++++++
 tools/perf/builtin-trace.c              |  110 +++++++++++++++++++++++++++----
 tools/perf/util/intlist.c               |   22 +++++--
 tools/perf/util/intlist.h               |    1 +
 tools/perf/util/rblist.c                |   27 +++++++-
 tools/perf/util/rblist.h                |    1 +
 7 files changed, 233 insertions(+), 19 deletions(-)

-- 
1.7.10.1

