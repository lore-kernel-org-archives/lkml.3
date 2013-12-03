Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3LCRIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:08:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:61114 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754063Ab3LCRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:08:34 -0500
Message-Id: <20131203170722.102711563@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 12:07:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 0/2] ktest: Added CLOSE_CONSOLE_SIGNAL
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ktest updates for linux-next.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
for-next

Head SHA1: 298a0d1d575026edec7fbb9b7e8cbb8fe18498cd


Satoru Takeuchi (1):
      ktest: Make the signal to terminate the console configurable

Steven Rostedt (Red Hat) (1):
      ktest: Add documentation of CLOSE_CONSOLE_SIGNAL

----
 tools/testing/ktest/ktest.pl    | 5 ++++-
 tools/testing/ktest/sample.conf | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)
