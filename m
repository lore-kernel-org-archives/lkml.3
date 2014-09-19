Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbaISN6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:58:00 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:57498 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624AbaISN56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:57:58 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH 0/2] powerpc32: Optimise some IP checksum functions.
Message-Id: <20140919135756.4F6A61AB26B@localhost.localdomain>
Date: Fri, 19 Sep 2014 15:57:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides a few optimisations related to IP checksum functions.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/include/asm/checksum.h | 28 ++++++++++++++++++++++++++++
 arch/powerpc/lib/checksum_32.S      | 16 ----------------
 2 files changed, 28 insertions(+), 16 deletions(-)
