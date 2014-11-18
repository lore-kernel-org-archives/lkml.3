Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaKRGfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:35:48 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:56973 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaKRGfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:35:47 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <dave.long@linaro.org>, <taras.kondratiuk@linaro.org>,
        <ben.dooks@codethink.co.uk>, <cl@linux.com>, <rabin@rab.in>,
        <davem@davemloft.net>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v8 0/2] ARM: kprobes: enable OPTPROBES for ARM32
Date: Tue, 18 Nov 2014 14:32:37 +0800
Message-ID: <1416292359-75893-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable OPTPROBES for ARM 32. Previous discussion can be found:

https://lkml.org/lkml/2014/10/25/48
https://lkml.org/lkml/2014/10/22/254
https://lkml.org/lkml/2014/8/27/255
https://lkml.org/lkml/2014/8/12/12
https://lkml.org/lkml/2014/8/8/992
https://lkml.org/lkml/2014/8/8/5
https://lkml.org/lkml/2014/8/5/63

This series of patches is depend on 'ARM: kprobes: introduces
instruction checker.', which can be found at:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/303525.html

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

