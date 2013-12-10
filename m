Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3LJMuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:50:23 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61922 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3LJMuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:50:22 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v5 0/3] More color in 'perf diff'
Date: Tue, 10 Dec 2013 18:18:59 +0530
Message-Id: <1386679742-13357-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The changes in this iteration are:

[1/3]: Use fabs() in get_percent_color() instead of
       __hpp_color_compare(), as suggested by Jiri.

[2/3]: Use value_color_snprintf(), a new function functionally
       equivalent to percent_color_snprintf().

[3/3]: Unchanged.

Thanks.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

Ramkumar Ramachandra (3):
  perf diff: color the Delta column
  perf diff: color the Ratio column
  perf diff: color the Weighted Diff column

 tools/perf/builtin-diff.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/color.c   | 16 ++++++---
 tools/perf/util/color.h   |  1 +
 3 files changed, 102 insertions(+), 6 deletions(-)

-- 
1.8.5.rc0.5.g70ebc73.dirty

