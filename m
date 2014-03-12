Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaCLWjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:39:51 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46807 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaCLWju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:39:50 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@imgtec.com>, Paul Bolle <pebolle@tiscali.nl>,
        Huacai Chen <chenhc@lemote.com>, Andreas Barth <aba@ayous.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH RESEND 0/2] MIPS: fix loongson2 regression
Date: Thu, 13 Mar 2014 00:41:05 +0200
Message-Id: <1394664067-17712-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

MIPS/Loongson2 got (again) broken during 3.14-rc merge window,
and so far we haven't been able to get fixes in through the MIPS
tree as there are still some issues with the tree maintenance.
Please consider applying these two fixes. The issues have been reported
and the fixes have been tested by several users. Thanks.

Earlier discussions:
	http://marc.info/?t=139178356200002&r=1&w=2
	http://marc.info/?t=139178356600001&r=1&w=2
	http://marc.info/?t=139183090100002&r=1&w=2
	http://marc.info/?t=139195288700001&r=1&w=2

Huacai Chen (1):
  MIPS: fpu: fix conflict of register usage

Paul Bolle (1):
  MIPS: Replace CONFIG_MIPS64 and CONFIG_MIPS32_R2

 arch/mips/include/asm/asmmacro.h |  4 ++--
 arch/mips/include/asm/fpu.h      |  2 +-
 arch/mips/kernel/r4k_fpu.S       | 16 ++++++++--------
 3 files changed, 11 insertions(+), 11 deletions(-)

-- 
1.9.0

