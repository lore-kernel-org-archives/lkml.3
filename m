Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaBQK2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:28:16 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:57743 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaBQK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:28:15 -0500
Date: Mon, 17 Feb 2014 11:28:12 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com
Subject: [GIT PULL] AVR32 fixes for 3.14
Message-ID: <20140217102812.GA3214@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

please pull

git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git for-linus

to receive the following AVR32 fixes for 3.14

Chen Gang (3):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use
      avr32: add generic ioremap_wc() definition in io.h
      avr32: add generic vga.h to Kbuild

Paul Gortmaker (1):
      avr32: fix missing module.h causing build failure in mimc200/fram.c

 arch/avr32/Makefile              | 2 +-
 arch/avr32/boards/mimc200/fram.c | 1 +
 arch/avr32/include/asm/Kbuild    | 1 +
 arch/avr32/include/asm/io.h      | 2 ++
 4 files changed, 5 insertions(+), 1 deletion(-)
-- 
mvh
Hans-Christian Egtvedt
