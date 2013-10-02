Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3JBMiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:38:02 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:32836 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3JBMiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:38:00 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, Russell King <rmk@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arm Linux <linux-arm-kernel@lists.infradead.org>
Subject: [GIT PULL] nohz: Full dynticks for 32 bits and arm support
Date: Wed,  2 Oct 2013 14:37:52 +0200
Message-Id: <1380717475-11505-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the timers/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/core

Thanks,
	Frederic
---

Kevin Hilman (3):
      vtime: Add HAVE_VIRT_CPU_ACCOUNTING_GEN Kconfig
      nohz: Drop generic vtime obsolete dependency on CONFIG_64BIT
      ARM: Kconfig: allow full nohz CPU accounting


 arch/Kconfig        | 12 ++++++++++++
 arch/arm/Kconfig    |  1 +
 init/Kconfig        |  3 ++-
 kernel/time/Kconfig |  2 +-
 4 files changed, 16 insertions(+), 2 deletions(-)
