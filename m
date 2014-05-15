Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaEOPJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:09:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:14792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaEOPJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:09:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="541004566"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [RFC 0/2] perf: add AUX space to ring_buffer
Date: Thu, 15 May 2014 18:08:28 +0300
Message-Id: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I tried to bend my head around the AUX space and this is where I am at
the moment. Not posting the whole itrace/PT bulk yet, to make sure
this part is ok and to save bandwidth.

Alexander Shishkin (1):
  perf: add data_{offset,size} to user_page

Peter Zijlstra (1):
  perf: add AUX area to ring buffer for raw data streams

 include/linux/perf_event.h      |  13 ++++
 include/uapi/linux/perf_event.h |  33 ++++++++++
 kernel/events/core.c            | 132 ++++++++++++++++++++++++++++++++--------
 kernel/events/internal.h        |  16 +++++
 kernel/events/ring_buffer.c     |  53 ++++++++++++++--
 5 files changed, 217 insertions(+), 30 deletions(-)

-- 
2.0.0.rc2

