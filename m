Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaDAHOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:14:08 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:46285 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaDAHOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:14:05 -0400
Date: Tue, 1 Apr 2014 09:14:03 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com
Subject: [GIT PULL] AVR32 updates for 3.15
Message-ID: <20140401071403.GA22628@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 20 Nov 2013 10:01:03 +0100 or thereabout, Hans-Christian Egtvedt wrote:
Hello Linus,

please pull

git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git for-linus

to receive the following AVR32 updates for 3.15

Chen Gang (1):
      arch/avr32/mm/cache.c: export symbol flush_icache_range() for module using

Ramkumar Ramachandra (1):
      avr32: replace simple_strtoul() with kstrtoul()

Wolfram Sang (1):
      avr32: remove cpu_data macro to fix compiles

 arch/avr32/include/asm/bugs.h      |  2 +-
 arch/avr32/include/asm/processor.h |  7 +------
 arch/avr32/kernel/cpu.c            | 48 ++++++++++++++++++++++++++----------------------
 arch/avr32/mm/cache.c              |  1 +
 4 files changed, 29 insertions(+), 29 deletions(-)
-- 
Best regards,
Hans-Christian Egtvedt
