Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3H0DwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:52:20 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40987 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3H0DwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:52:19 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3] perf trace enhancements
Date: Mon, 26 Aug 2013 21:52:12 -0600
Message-Id: <1377575535-43544-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo:

A couple of enhancements to perf-trace: ability to analyze events from a
file and when processing a file limit the analysis to a given set of
pid and tids.


David Ahern (3):
  perf evlist: Add tracepoint lookup by name
  perf trace: Add option to analyze events in a file versus live
  perf trace: Honor target pid / tid options when analyzing a file

 tools/perf/Documentation/perf-trace.txt |    4 +
 tools/perf/builtin-trace.c              |  135 ++++++++++++++++++++++++++++++-
 tools/perf/util/evlist.c                |   15 ++++
 tools/perf/util/evlist.h                |    4 +
 4 files changed, 157 insertions(+), 1 deletion(-)

-- 
1.7.10.1

