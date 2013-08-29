Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3H2E37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 00:29:59 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36604 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3H2E36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 00:29:58 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3] perf trace enhancements - v2
Date: Wed, 28 Aug 2013 22:29:50 -0600
Message-Id: <1377750593-48046-1-git-send-email-dsahern@gmail.com>
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
  perf trace: Add option to analyze events in a file versus live - v2
  perf trace: Honor target pid / tid options when analyzing a file

 tools/perf/Documentation/perf-trace.txt |    4 +
 tools/perf/builtin-trace.c              |  141 ++++++++++++++++++++++++++++++-
 tools/perf/util/evlist.c                |   15 ++++
 tools/perf/util/evlist.h                |    4 +
 4 files changed, 162 insertions(+), 2 deletions(-)

-- 
1.7.10.1

