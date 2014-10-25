Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaJYTBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:01:37 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:42366 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaJYTBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:01:33 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>, <dave.long@linaro.org>,
        <taras.kondratiuk@linaro.org>, <ben.dooks@codethink.co.uk>,
        <cl@linux.com>, <rabin@rab.in>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lizefan@huawei.com>
Subject: [PATCH v7 0/2] ARM: kprobes: enable OPTPROBES for ARM 32.
Date: Sat, 25 Oct 2014 14:51:03 +0800
Message-ID: <1414219865-35988-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 7th version of ARM KPROBEOPT patch series.  This patch
series is depend on previous patch series I have posted: 'ARM: kprobes:
introduces instruction checker.'.

Previous discussions can be found:

https://lkml.org/lkml/2014/10/22/254
https://lkml.org/lkml/2014/8/27/255
https://lkml.org/lkml/2014/8/12/12
https://lkml.org/lkml/2014/8/8/992
https://lkml.org/lkml/2014/8/8/5
https://lkml.org/lkml/2014/8/5/63

The main content of this patch series is identical to patch 6/7 and 7/7
in v6. I post a v7 series because Masami Hiramatsu suggests me to make
the ARM OPTPROBES and the checker mechanism two sepreted series.

Wang Nan (2):
  kprobes: copy ainsn after alloc aggr kprobe
  ARM: kprobes: enable OPTPROBES for ARM 32

 arch/arm/Kconfig                  |   1 +
 arch/arm/include/asm/kprobes.h    |  26 ++++
 arch/arm/kernel/Makefile          |   3 +-
 arch/arm/kernel/kprobes-opt-arm.c | 285 ++++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c                  |   6 +
 5 files changed, 320 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/kernel/kprobes-opt-arm.c

-- 
1.8.4

