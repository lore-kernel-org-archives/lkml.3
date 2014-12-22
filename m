Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaLVC22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:28:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17564 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaLVC21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:28:27 -0500
Message-ID: <549781C3.50407@oracle.com>
Date: Sun, 21 Dec 2014 21:28:19 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Kirill Smelkov <kirr@nexedi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] liblockdep fixes for v3.19
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

A small (but important) fix to the way we detect freeing live locks. We would
pass a wrong memory region when testing for locks inside freed memory spaces,
which would trigger false positives.


Thanks,
Sasha

The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git liblockdep-fixes-3.19

for you to fetch changes up to 95bfdf23e4d59099340c01064f39e7f6875c02bc:

  tools/liblockdep: Fix debug_check thinko in mutex destroy (2014-12-19 15:50:55 -0500)

----------------------------------------------------------------
Kirill Smelkov (1):
      tools/liblockdep: Fix debug_check thinko in mutex destroy

 tools/lib/lockdep/preload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
