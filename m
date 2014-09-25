Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaIYU0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:26:07 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38361 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaIYU0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:26:06 -0400
Date: Thu, 25 Sep 2014 13:25:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: New build failures in Sep 25 tree
Message-ID: <20140925202559.GA1750@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build results:
	total: 133 pass: 115 fail: 18
Failed builds:
	alpha:defconfig
	alpha:allmodconfig
	arc:defconfig
	i386:allyesconfig
	i386:allmodconfig
	m68k:allmodconfig
	mips:allmodconfig
	openrisc:defconfig
	powerpc:cell_defconfig
	powerpc:ppc6xx_defconfig
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	powerpc:cell_defconfig
	powerpc:ppc6xx_defconfig
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	tile:tilegx_defconfig
	xtensa:allmodconfig

---

New build failures:

---
arc:defconfig

arch/arc/kernel/setup.c: In function 'customize_machine':
arch/arc/kernel/setup.c:354: error: implicit declaration of function 'of_clk_init'

---
mips:allmodconfig

arch/mips/net/bpf_jit.c: In function 'build_body':
arch/mips/net/bpf_jit.c:762:6: error: unused variable 'tmp' [-Werror=unused-variable]

---
openrisc-defconfig

In file included from arch/openrisc/kernel/signal.c:31:0:
./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared

---
tile:defconfig

In file included from sound/pci/cs46xx/dsp_spos.c:25:0:
include/linux/pm.h: In function ‘dev_pm_domain_attach’:
include/linux/pm.h:631:10: error: ‘ENODEV’ undeclared
make[3]: *** [sound/pci/cs46xx/dsp_spos.o] Error 1

---

Guenter
