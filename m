Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3KXKc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 05:32:57 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47087 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3KXKcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 05:32:55 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 0/4] hw_breakpoints: Fix a bunch of adress range fixes
Date: Sun, 24 Nov 2013 11:32:47 +0100
Message-Id: <1385289171-3411-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It was initially a single patch that Oleg sent me a few weeks ago. Thinking
about it I think it may need a stable backport even though it doesn't look
very dangerous, but just in case.

So I've splitted the patch in 4 different parts because it may need
backporting on different tree version for each arch concerned.

Of course we need to consolidate that range check somewhere but after the
stable backport.

Comments.


Thanks,
	Frederic
---

Oleg Nesterov (4):
      arm: Fix the hw_breakpoint range check
      x86: Fix the hw_breakpoint range check
      arm64: Fix the hw_breakpoint range check
      sh: Fix hw_breakpoint the range check


 arch/arm/kernel/hw_breakpoint.c   | 2 +-
 arch/arm64/kernel/hw_breakpoint.c | 2 +-
 arch/sh/kernel/hw_breakpoint.c    | 2 +-
 arch/x86/kernel/hw_breakpoint.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)
