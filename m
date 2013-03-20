Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3CTXec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:34:32 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:34281 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3CTXeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:34:31 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 0/3] ARM: context tracking support prerequisites
Date: Wed, 20 Mar 2013 16:34:24 -0700
Message-Id: <1363822467-6275-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is a set of prerequistes for getting the new context
tracking subsystem, and adaptive tickless support working on ARM.

Kevin Hilman (3):
  cputime_nsecs: use math64.h for nsec resolution conversion helpers
  init/Kconfig: virt CPU accounting: drop 64-bit requirment
  ARM: Kconfig: allow virt CPU accounting

 arch/arm/Kconfig                    |  1 +
 include/asm-generic/cputime_nsecs.h | 28 +++++++++++++++++++---------
 init/Kconfig                        |  2 +-
 3 files changed, 21 insertions(+), 10 deletions(-)

-- 
1.8.2

