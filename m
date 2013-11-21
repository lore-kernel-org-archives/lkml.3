Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3KUOoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:44:21 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53164 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3KUOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:43:02 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/4] More color in 'perf diff'
Date: Thu, 21 Nov 2013 20:03:43 +0530
Message-Id: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I thought it would be nice to color the Delta column as a short
evening exercise. While at it, I thought it would be nice to color the
Ratio column (see [4/4]) as well. It's trivial to write a patch to
color the Weighted Diff column now, but I haven't done so because of
the problem in [4/4].

Thanks.

Ramkumar Ramachandra (4):
  perf diff: don't compute Delta if he->dummy
  perf diff: give Delta column an appropriate color
  perf diff: generalize hpp__color_delta for -c
  perf diff: give Ratio column an appropriate color

 tools/perf/builtin-diff.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 85 insertions(+), 1 deletion(-)

-- 
1.8.5.rc0.5.g70ebc73.dirty

