Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3K2NqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:46:18 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65116 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab3K2NqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:46:17 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v4 0/3] More color in 'perf diff'
Date: Fri, 29 Nov 2013 19:06:29 +0530
Message-Id: <1385732192-27713-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Two minor changes in this iteration:

- The numbers in [1/3] are colored using percent_color_snprintf()
  instead of using (green, red) for (positive, negative).

- Two of the patches in the previous iteration were squashed together
  to make [2/3] in this iteration.

Thanks again to Jiri Olsa.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

Ramkumar Ramachandra (3):
  perf diff: color the Delta column
  perf diff: color the Ratio column
  perf diff: color the Weighted Diff column

 tools/perf/builtin-diff.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 90 insertions(+), 1 deletion(-)

-- 
1.8.5.rc0.5.g70ebc73.dirty

