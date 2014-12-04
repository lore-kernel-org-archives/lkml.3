Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaLDP4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:56:02 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:35156 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754750AbaLDPz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:55:59 -0500
Message-Id: <20141204155517.575600663@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 04 Dec 2014 10:55:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 0/2] ftracetests: Testing updates for 3.19
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 57cee23650d768130ff2d80aa4cd0b053feabf97


Masami Hiramatsu (2):
      ftracetest: Fix to show descriptions on dash
      ftracetest: Add --verbose option for showing echo output

----
 tools/testing/selftests/ftrace/ftracetest | 36 +++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 11 deletions(-)
