Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3KPRjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 12:39:40 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:59438 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3KPRjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 12:39:32 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/5] Command line related cleanups
Date: Sat, 16 Nov 2013 11:32:26 -0600
Message-Id: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These became apparent in the review process of a new command line parameter.

Felipe Contreras (5):
  kstrtox: remove redundant cleanup
  cmdline: fix style issues
  cmdline: declare exported symbols immediately
  kstrtox: remove redundant casts
  params: improve standard definitions

 kernel/params.c | 25 +++++++++----------------
 lib/cmdline.c   | 14 ++++++--------
 lib/kstrtox.c   | 17 ++++++++---------
 3 files changed, 23 insertions(+), 33 deletions(-)

-- 
1.8.4.2+fc1

