Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386Ab3CNDpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 23:45:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:43567 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab3CNDo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 23:44:59 -0400
X-Spam-Score: -100.8
Message-ID: <514147A0.2060002@asianux.com>
Date: Thu, 14 Mar 2013 11:44:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lorenzo.pieralisi@arm.com,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, nico@linaro.org,
        catalin.marinas@arm.com
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] Latest randconfig build errors for CONFIG_MMU=no
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

  when use randconfig:
    make V=1 EXTRA_CFLAGS=-W ARCH=arm randconfig
      (and "grep CONFIG_MMU .config" outputs "# CONFIG_MMU is not set")

  the error information:
    arch/arm/kernel/suspend.c: 在函数‘cpu_suspend’中:
    arch/arm/kernel/suspend.c:56:32: 错误：提领指向不完全类型的指针
    arch/arm/kernel/suspend.c:70:3: 错误：隐式声明函数‘cpu_switch_mm’ [-Werror=implicit-function-declaration]
    arch/arm/kernel/suspend.c:71:3: 错误：隐式声明函数‘local_flush_bp_all’ [-Werror=implicit-function-declaration]
    arch/arm/kernel/suspend.c:72:3: 错误：隐式声明函数‘local_flush_tlb_all’ [-Werror=implicit-function-declaration]

  I want to be sure whether we can bear it ?

  thanks.

-- 
Chen Gang

Asianux Corporation
