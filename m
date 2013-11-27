Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3K0LMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:12:24 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40244 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3K0LMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:12:20 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH v3 0/4] More color in 'perf diff'
Date: Wed, 27 Nov 2013 16:32:30 +0530
Message-Id: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This iteration fixes several small problems in the previous iteration
pointed out by Jiri Olsa. Most significantly, the first patch has been
dropped, and there's just one switch-case statement for the entire
logic.

Thanks.

Ramkumar Ramachandra (4):
  perf diff: color the Delta column
  perf diff: generalize hpp__color_delta for -c
  perf diff: color the Ratio column
  perf diff: color the Weighted Diff column

 tools/perf/builtin-diff.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

-- 
1.8.5.rc0.5.g70ebc73.dirty

