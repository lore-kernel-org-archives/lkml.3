Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaBZPpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:45:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaBZPpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:45:39 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: acme@ghostprotocols.net, jolsa@redhat.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/2] perf: thread fixes
Date: Wed, 26 Feb 2014 10:45:25 -0500
Message-Id: <1393429527-167840-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixups for synthesizing thread maps and locating them later

Don Zickus (2):
  perf: fix synthesizing mmaps for threads
  perf: Use tid in mmap/mmap2 events to find maps

 tools/perf/util/event.c   | 111 +++++++++++++++++++++++-----------------------
 tools/perf/util/machine.c |   4 +-
 2 files changed, 58 insertions(+), 57 deletions(-)

-- 
1.7.11.7

