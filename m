Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab3I1U2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:28:08 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34855 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3I1U2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:28:06 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/3] perf stat cleanups
Date: Sat, 28 Sep 2013 14:27:57 -0600
Message-Id: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo:

A few perf-stat cleanups.

David Ahern (3):
  perf stat: Fix misleading message when specifying cpu list or system wide
  perf stat: Don't require a workload when using system wide or CPU options
  perf stat: Add units to nanosec-based counters

 tools/perf/builtin-stat.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

-- 
1.7.10.1

