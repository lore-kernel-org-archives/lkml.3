Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936158AbaFIJVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:21:36 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:50113 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933386AbaFIJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:21:28 -0400
X-Yandex-Uniq: 2e3d92a9-d1c4-4de2-bd6b-12b19e50ecfc
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] perf timechart fix & io mode
Date: Mon,  9 Jun 2014 13:21:10 +0400
Message-Id: <1402305672-2630-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf timechart: fix documentation
  moves misplaced options into appropriate place

perf timechart: implement IO mode
  adds io mode, instead of process time we record io syscalls and then
  draw timechart of writes/reads/tx/rx/polls

Stanislav Fomichev (2):
  perf timechart: fix documentation
  perf timechart: implement IO mode

 tools/perf/Documentation/perf-timechart.txt |  55 ++-
 tools/perf/builtin-timechart.c              | 646 +++++++++++++++++++++++++++-
 tools/perf/util/svghelper.c                 |  98 ++++-
 tools/perf/util/svghelper.h                 |   6 +-
 4 files changed, 769 insertions(+), 36 deletions(-)

-- 
1.8.3.2

