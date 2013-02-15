Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948Ab3BOKlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:41:52 -0500
Received: from multi.imgtec.com ([194.200.65.239]:34295 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab3BOKlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:41:51 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/6] metag: metag_ksyms.c cleanup
Date: Fri, 15 Feb 2013 10:41:35 +0000
Message-ID: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_15_10_41_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some fairly trivial metag_ksyms.c/EXPORT_SYMBOL cleanups which
I'll add to the arch/metag tree for v3.9-rc1.

Basically they move EXPORT_SYMBOLs to after the actual definitions for
those symbols defined in C files, and clean up the includes in
metag_ksyms.c.

James Hogan (6):
  metag: move traps.c exports out of metag_ksyms.c
  metag: move kick.c exports out of metag_ksyms.c
  metag: move setup.c exports out of metag_ksyms.c
  metag: move usercopy.c exports out of metag_ksyms.c
  metag: move mm/init.c exports out of metag_ksyms.c
  metag: cleanup metag_ksyms.c includes

 arch/metag/kernel/kick.c        |    3 +++
 arch/metag/kernel/metag_ksyms.c |   39 +++------------------------------------
 arch/metag/kernel/setup.c       |    3 +++
 arch/metag/kernel/traps.c       |    3 +++
 arch/metag/lib/usercopy.c       |   13 +++++++++++++
 arch/metag/mm/init.c            |    3 +++
 6 files changed, 28 insertions(+), 36 deletions(-)

-- 
1.7.7.6


