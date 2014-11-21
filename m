Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbaKUGjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:39:01 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:53842 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbaKUGi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:38:59 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <taras.kondratiuk@linaro.org>, <ben.dooks@codethink.co.uk>,
        <cl@linux.com>, <rabin@rab.in>, <davem@davemloft.net>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v10 0/2] ARM: kprobes: enable OPTPROBES for ARM32
Date: Fri, 21 Nov 2014 14:35:49 +0800
Message-ID: <1416551751-50846-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the tenth (and final I hope) version of OPTPROBES for ARM32.

Previous discussion can be found:

https://lkml.org/lkml/2014/11/19/31
https://lkml.org/lkml/2014/11/18/41
https://lkml.org/lkml/2014/10/25/48
https://lkml.org/lkml/2014/10/22/254
https://lkml.org/lkml/2014/8/27/255
https://lkml.org/lkml/2014/8/12/12
https://lkml.org/lkml/2014/8/8/992
https://lkml.org/lkml/2014/8/8/5
https://lkml.org/lkml/2014/8/5/63

There is no code change in this patch series, only commit message
cleanup: move version information after '---' in patch 2.

Masami Hiramatsu (1):
  kprobes: Pass the original kprobe for preparing optimized kprobe

Wang Nan (1):
  ARM: kprobes: enable OPTPROBES for ARM 32

 arch/arm/Kconfig                  |   1 +
 arch/arm/include/asm/kprobes.h    |  26 ++++
 arch/arm/kernel/Makefile          |   3 +-
 arch/arm/kernel/kprobes-opt-arm.c | 290 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes/opt.c     |   3 +-
 include/linux/kprobes.h           |   3 +-
 kernel/kprobes.c                  |   4 +-
 7 files changed, 325 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/kernel/kprobes-opt-arm.c

-- 
1.8.4

