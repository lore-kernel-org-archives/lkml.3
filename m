Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaAOP3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:29:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:24996 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752013AbaAOP3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:29:12 -0500
Message-Id: <20140115152805.592972467@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 Jan 2014 10:28:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/2] ktest: A couple of updates
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
for-next

Head SHA1: c75d22d9c675c4c77d87ff36de6e5023f14724ef


Steven Rostedt (Red Hat) (2):
      ktest: Add special variable ${KERNEL_VERSION}
      ktest: Add eval '=~' command to modify variables in config file

----
 tools/testing/ktest/ktest.pl | 129 +++++++++++++++++++++++++++++++++----------
 1 file changed, 100 insertions(+), 29 deletions(-)
