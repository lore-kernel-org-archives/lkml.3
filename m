Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaAKRsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:48:50 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:41887 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaAKRst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:48:49 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] perf: little build clean up
Date: Sat, 11 Jan 2014 18:48:14 +0100
Message-Id: <cover.1389461371.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find 2 little patches to remove an unused file
and to ignore files generated as part of the feature
auto-detection.

Regards.

Yann Droneaud (2):
  perf tools: remove unused test-volatile-register-var.c
  perf tools: add .gitignore for files generated for feature check

 tools/perf/config/feature-checks/.gitignore        | 28 ++++++++++++++++++++++
 .../feature-checks/test-volatile-register-var.c    |  6 -----
 2 files changed, 28 insertions(+), 6 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/.gitignore
 delete mode 100644 tools/perf/config/feature-checks/test-volatile-register-var.c

-- 
1.8.4.2

