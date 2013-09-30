Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3I3LTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:19:53 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54607 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3I3LTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:19:50 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 0/2] Toying with the perf tool
Date: Mon, 30 Sep 2013 16:43:03 +0530
Message-Id: <1380539585-23859-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was curiously poking around the perf tool this morning. The hacking
session resulted in two minor patches:

[1/2] is a minor non-functional cleanup of the Makefile.
[2/2] is more important: it omits printing bogus data in an edge case.

Thanks for reading.

Ramkumar Ramachandra (2):
  perf tool: simplify ARCH code in Makefile
  perf tool: don't print bogus data on -e cycles

 tools/perf/builtin-stat.c  |  9 ++++-----
 tools/perf/config/Makefile | 47 ++++++++++++++++++++++------------------------
 2 files changed, 26 insertions(+), 30 deletions(-)

-- 
1.8.4.477.g5d89aa9

