Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaKXPng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:43:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:55533 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752754AbaKXPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:43:33 -0500
Message-Id: <20141124154251.345600733@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 24 Nov 2014 10:42:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/5] ktest: Updates for 3.19
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
for-next

Head SHA1: 17150fef4ab1f48d838008657cdaa168453a9fa6


Michal Marek (1):
      ktest: Use make -s kernelrelease

Steven Rostedt (Red Hat) (4):
      ktest: Fix make_min_config to handle new assign_configs call
      ktest: Allow tests to undefine default options
      ktest: Add name to running title
      ktest: Add back "tail -1" to kernelrelease make

----
 tools/testing/ktest/ktest.pl | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)
