Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab3GCSgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:36:46 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50782 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab3GCSgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:36:45 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 0/3] nohz/full: final Kconfig bits for ARM support
Date: Wed,  3 Jul 2013 11:36:38 -0700
Message-Id: <1372876601-23881-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of v3.10, the core ARM support is in mainline for NO_HZ_FULL.  The
only remaining part is the removal of the hard-coded Kconfig
requirement on 64-bit platforms, which I believe can now be removed
after the nsec granularity cputime was made to work on non 64_BIT
(c.f. commit 8c23b80e, cputime_nsecs: use math64.h for nsec
resolution conversion helpers.)

This series makes the final Kconfig changes to bring NO_HZ_FULL
support to ARM.

Series applies to v3.10.

I will queue up the arch/arm patch for Russell separately once the
generic changes are accepted.

Kevin

 arch/arm/Kconfig    | 1 +
 init/Kconfig        | 2 +-
 kernel/time/Kconfig | 2 --
 3 files changed, 2 insertions(+), 3 deletions(-)

-- 
1.8.3

