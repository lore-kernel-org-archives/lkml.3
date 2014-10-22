Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbaJVVHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:07:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:44398 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037AbaJVVHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:07:05 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/1] perf/urgent fix
Date: Wed, 22 Oct 2014 18:06:56 -0300
Message-Id: <1414012017-26261-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 3b10ea7f922b538ba5dcb3d979a6b6b4d07daae2:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-10-18 09:04:02 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo

for you to fetch changes up to 9ab1f50876dbb8b962db058259be7aae920d4c25:

  perf diff: Add missing hists__init() call at tool start (2014-10-22 16:31:06 -0300)

----------------------------------------------------------------
perf/urgent fix:

* Fix 'perf diff' initialization, calling the recently added hists__init()
  function so that extra space is allocated per perf_evsel for the hists storage
  that it also uses, just like report and top.  (Kan Liang)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Kan Liang (1):
      perf diff: Add missing hists__init() call at tool start

 tools/perf/builtin-diff.c | 5 +++++
 1 file changed, 5 insertions(+)
