Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab3EVTJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:09:35 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:45389 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab3EVTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:09:33 -0400
Date: Wed, 22 May 2013 21:09:28 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com
Subject: [GIT PULL] AVR32 update for 3.10
Message-ID: <20130522190928.GA4314@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

please pull

git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git for-linus

to receive the following AVR32 updates for 3.10 (wow, it has gone 10 releases
since my last request :( ).

Hans-Christian Egtvedt (2):
      avr32: move NODES_SHIFT into Kconfig and delete numnodes.h
      avr32: fix relocation check for signed 18-bit offset

Jiang Liu (1):
      avr32: fix building warnings caused by redefinitions of HZ

 arch/avr32/Kconfig                  |    5 +++++
 arch/avr32/include/asm/Kbuild       |    1 +
 arch/avr32/include/asm/numnodes.h   |    7 -------
 arch/avr32/include/asm/param.h      |    9 ---------
 arch/avr32/include/uapi/asm/Kbuild  |    1 +
 arch/avr32/include/uapi/asm/param.h |   18 ------------------
 arch/avr32/kernel/module.c          |    2 +-
 7 files changed, 8 insertions(+), 35 deletions(-)
 delete mode 100644 arch/avr32/include/asm/numnodes.h
 delete mode 100644 arch/avr32/include/asm/param.h
 delete mode 100644 arch/avr32/include/uapi/asm/param.h

-- 
Best regards,
Hans-Christian Egtvedt
