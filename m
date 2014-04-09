Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbaDIOWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:22:17 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:42071 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaDIOWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:22:15 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PULL 0/2] small perf fixes
Date: Wed,  9 Apr 2014 16:21:57 +0200
Message-Id: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040914-3548-0000-0000-000008ADFF77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Arnaldo,

two fixes indentified during kvm on s390 development are available 

since commit 538592ff0b008237ae88f5ce5fb1247127dc3ce5:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-03-19 08:05:47 +0100)

in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/perf-fixes

for you to fetch changes up to 5e032c6c3eaf499460e3ca6b9586c7605c16004e:

  perf-kvm: fix of 'Min time' counting in report command (2014-04-09 16:06:15 +0200)

Please consider to apply.

----------------------------------------------------------------
Provide two fixes for perf:
- allow "-" in trace names. This enables perf to also handle kvm-s390
- fix min accounting in for perf kvm

----------------------------------------------------------------
Alexander Yarygin (2):
      perf/tool: Fix usage of trace events with '-' in trace system name.
      perf-kvm: fix of 'Min time' counting in report command

 tools/perf/builtin-kvm.c       |    1 +
 tools/perf/util/parse-events.l |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

