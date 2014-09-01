Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaIANsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:48:23 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:38696 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaIANsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:48:21 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCHv2 0/3] perf kvm stat report: extend the title bar output
Date: Mon,  1 Sep 2014 17:44:52 +0400
Message-Id: <1409579095-12963-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090113-3548-0000-0000-00000136DDC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset is intended to add information about current pid to the
"Analyze events for " title bar for the 'perf kvm stat report' command,
when it's running with --pid option. To do so, patches 1-2 sync values
of kvm->opts.target in 'report' with 'live' command and patch 3 reuses
'live' specific code to print desirable information.

v2 changes:
   - Split the big patch into 3 small patches
   - Simplified the way to enable target.system_wide flag

Thanks.

Alexander Yarygin (3):
  perf kvm stat report: Save pid string in kvm->opts.target.pid
  perf kvm stat report: Enable the target.system_wide flag
  perf kvm stat report: Unify the title bar output

 tools/perf/builtin-kvm.c   |   23 ++++++++++++-----------
 tools/perf/util/kvm-stat.h |    1 -
 2 files changed, 12 insertions(+), 12 deletions(-)

--
1.7.9.5

