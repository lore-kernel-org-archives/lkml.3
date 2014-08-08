Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbaHHQsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:48:52 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57514 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097AbaHHQrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:47:46 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 3/7] ARM: SoC board changes for 3.17
Date: Fri,  8 Aug 2014 09:47:55 -0700
Message-Id: <1407516479-1251-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 2.0.1.473.gc4d58ca
In-Reply-To: <1407516479-1251-1-git-send-email-olof@lixom.net>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the smallest board branch we have ever had. Most of this is a
few cleanups for board code for Renesas shmobile, with a bit of legacy
driver support added. This is strongly trending in the right direction now.



Conflicts: None

----------------------------------------------------------------

The following changes since commit af0de725999369f7b9a6d2a0b41c09178b4814d8:

  Merge branch 'next/soc' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards-for-3.17

for you to fetch changes up to bdd18e8f76e33151a850906c8353222bd06a49e6:

  Merge tag 'renesas-boards-for-v3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/boards

----------------------------------------------------------------

Geert Uytterhoeven (4):
      ARM: shmobile: koelsch-reference: Remove workarounds for core clock issues
      ARM: shmobile: lager-reference: Remove workarounds for core clock issues
      ARM: shmobile: armadillo800eva legacy: Add LED support
      ARM: shmobile: armadillo800eva reference: Spelling s/ED/LED/

Magnus Damm (1):
      ARM: shmobile: Enable R-Car Gen2 CMA code in board files

Olof Johansson (1):
      Merge tag 'renesas-boards-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/boards


 .../board-armadillo800eva-reference.c           |  8 ++---
 arch/arm/mach-shmobile/board-armadillo800eva.c  | 35 ++++++++++++++++++++
 .../arm/mach-shmobile/board-koelsch-reference.c | 16 +--------
 arch/arm/mach-shmobile/board-koelsch.c          |  1 +
 arch/arm/mach-shmobile/board-lager-reference.c  | 15 +--------
 arch/arm/mach-shmobile/board-lager.c            |  1 +
 6 files changed, 43 insertions(+), 33 deletions(-)
