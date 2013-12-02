Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3LBAXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 19:23:33 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35510 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3LBAXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 19:23:30 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: namhyung@kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/2] perf: sched timehist command - v2
Date: Sun,  1 Dec 2013 17:23:13 -0700
Message-Id: <1385943795-11761-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addressed comments by Namhyung (thank you!).

David Ahern (2):
  perf sched: Introduce timehist command - v2
  perf sched: Add documentation for timehist options

 tools/perf/Documentation/perf-sched.txt |  61 ++-
 tools/perf/builtin-sched.c              | 932 +++++++++++++++++++++++++++++++-
 tools/perf/perf.h                       |   3 +
 3 files changed, 994 insertions(+), 2 deletions(-)

-- 
1.8.3.4 (Apple Git-47)

