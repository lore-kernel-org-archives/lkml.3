Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaIVNdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:33:12 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:40567 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbaIVNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:33:10 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Minor MIPS ftrace fixes
Date: Mon, 22 Sep 2014 14:32:57 +0100
Message-ID: <1411392779-9554-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A few more fixes for ftrace/MIPS. The first patch fixes the
value of the MCOUNT_INSN_SIZE definition which holds the
total size of the mcount() call. The second one, fixes
the selfpc argument for the ftrace tracing function.

Markos Chandras (2):
  MIPS: ftrace.h: Fix the MCOUNT_INSN_SIZE definition
  MIPS: mcount: Fix selfpc address for static trace

 arch/mips/include/asm/ftrace.h | 2 +-
 arch/mips/kernel/ftrace.c      | 4 +++-
 arch/mips/kernel/mcount.S      | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.1.0

