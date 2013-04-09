Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937024Ab3DIIUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:20:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:48237 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3DIIUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:20:10 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL] at91: little cleanup for 3.10 #3
Date: Tue, 9 Apr 2013 10:20:07 +0200
Message-ID: <1365495607-30320-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Again more trivial cleanup for AT91. It is based on material already sent and
present in arm-soc/at91/cleanup2.

Thanks, best regards,

The following changes since commit e7619459d47a673af3433208a42f583af920e9db:

  ARM: at91: Fix typo in restart code panic message (2013-03-26 12:21:25 +0100)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-cleanup

for you to fetch changes up to 3aa630b3e6be83c4e91a68537fe6edf80f8d295e:

  ARM: at91: remove trailing semicolon from macros (2013-04-08 17:47:44 +0200)

----------------------------------------------------------------
Trivial typos and some macros removal & modification

----------------------------------------------------------------
Johan Hovold (2):
      ARM: at91/setup: fix trivial typos
      ARM: at91: remove trailing semicolon from macros

Nicolas Ferre (1):
      ARM: at91: remove unused dbgu_readl() macro

 arch/arm/mach-at91/at91_rstc.h                | 2 +-
 arch/arm/mach-at91/at91_shdwc.h               | 2 +-
 arch/arm/mach-at91/at91x40_time.c             | 2 +-
 arch/arm/mach-at91/include/mach/at91_dbgu.h   | 3 ---
 arch/arm/mach-at91/include/mach/at91_matrix.h | 2 +-
 arch/arm/mach-at91/include/mach/at91_st.h     | 2 +-
 arch/arm/mach-at91/setup.c                    | 6 +++---
 7 files changed, 8 insertions(+), 11 deletions(-)

-- 
Nicolas Ferre
