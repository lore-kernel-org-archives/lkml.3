Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaBZDn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:43:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaBZDn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:43:56 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: acme@ghostprotocols.net, jolsa@redhat.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/3] perf: misc fixes
Date: Tue, 25 Feb 2014 22:43:44 -0500
Message-Id: <1393386227-149412-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a small collection of fixes noticed while hacking up the c2c tool

Don Zickus (3):
  perf, machine: Use map as success in ip__resolve_ams
  perf, session: Change header.misc dump from decimal to hex
  perf: fix synthesizing mmaps for threads

 tools/perf/util/event.c   | 15 +++++++++++----
 tools/perf/util/machine.c |  6 +++---
 tools/perf/util/session.c |  2 +-
 3 files changed, 15 insertions(+), 8 deletions(-)

-- 
1.7.11.7

