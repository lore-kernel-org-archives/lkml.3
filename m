Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3L3Hd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:33:57 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47207 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3L3Hd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:33:56 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v6 0/4] More color in 'perf diff'
Date: Mon, 30 Dec 2013 13:04:17 +0530
Message-Id: <1388388861-7931-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The differences in this series are:

- [1/4] and [2/4] have been split out.
- [4/4] uses value_color_snprintf() instead of green/ red for positive/
  negative values.

Thanks.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

Ramkumar Ramachandra (4):
  perf tools: generalize percent_color_snprintf()
  perf diff: color the Delta column
  perf diff: color the Ratio column
  perf diff: color the Weighted Diff column

 tools/perf/builtin-diff.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/color.c   | 15 +++++---
 tools/perf/util/color.h   |  1 +
 3 files changed, 100 insertions(+), 6 deletions(-)

-- 
1.8.5.2.227.g53f3478

