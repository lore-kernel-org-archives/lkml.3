Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaCQW0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:26:00 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:60652 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaCQWZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:25:55 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] Squelch warnings emitted by 'perf test'
Date: Mon, 17 Mar 2014 18:26:33 -0400
Message-Id: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The motivation for the series is mainly [2/5] and [5/5] -- to squelch
the warnings emitted by 'perf test'. I made some effort to understand
what's going on, but I didn't get very far. [5/5] feels especially
like a band-aid fix: please let me know how to do it right.

Thanks.

Ramkumar Ramachandra (5):
  MAINTAINERS: add tools/lib/traceevent/ to perf subsystem
  tools lib traceevent: handle the '->' operator
  tools lib traceevent: use else-if cascade, not separate ifs
  tools lib traceevent: field_is_long() includes unsigned long
  perf test: squelch warnings about undefined sizeof

 MAINTAINERS                        |  1 +
 tools/lib/traceevent/event-parse.c | 23 +++++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

-- 
1.9.0.431.g014438b

