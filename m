Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3KXG3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 01:29:35 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45522 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3KXG3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 01:29:33 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH v2 0/5] More color in 'perf diff'
Date: Sun, 24 Nov 2013 11:50:20 +0530
Message-Id: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This round fixes two problems in the last round:

- In [2/5], the color version includes the 0.01 threshold that was
  present in the non-color version (thanks to Jiri).

- In [4/5], the trailing '%' is gone (maked as a TODO in the last
  round).

and introduces one new patch for wdiff: [5/5].

Thanks.

Ramkumar Ramachandra (5):
  perf diff: don't compute Delta if he->dummy
  perf diff: color the Delta column
  perf diff: generalize hpp__color_delta for -c
  perf diff: color the Ratio column
  perf diff: color the Weighted Diff column

 tools/perf/builtin-diff.c | 109 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 108 insertions(+), 1 deletion(-)

-- 
1.8.5.rc0.5.g70ebc73.dirty

