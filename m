Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaITAPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 20:15:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:58462 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756485AbaITAP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 20:15:29 -0400
Message-Id: <20140920001506.161041448@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 19 Sep 2014 20:15:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/2] ktest: Updates for 3.18
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
for-next

Head SHA1: fee9d3e61d04422628a3d22ed5eb8370dcef259b


Chris J Arges (1):
      ktest: add ability to skip during BISECT_MANUAL

Steven Rostedt (Red Hat) (1):
      ktest: Add PATCHCHECK_CHERRY

----
 tools/testing/ktest/ktest.pl    | 41 +++++++++++++++++++++++++++++++++--------
 tools/testing/ktest/sample.conf | 10 ++++++++++
 2 files changed, 43 insertions(+), 8 deletions(-)
