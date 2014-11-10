Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaKJJBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:01:53 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50841 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaKJJBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:01:51 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: jslaby@suse.cz, linux@arm.linux.org.uk, rostedt@goodmis.org,
        mingo@redhat.com, nsekhar@ti.com, stefano.stabellini@eu.citrix.com,
        christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 00/01] arm: ftrace: Adds support for CONFIG_DYNAMIC_FTRACE_WITH_REGS
Date: Mon, 10 Nov 2014 09:56:16 +0100
Message-Id: <1415609777-18525-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141107115225.72bc6cbf@gandalf.local.home>
References: <20141107115225.72bc6cbf@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for ftrace operations on the ARM architecture.
This support is needed by kgraft and possibly other ftrace-based tools.
My goal is to have kgraft working on ARM and aarch64.

I tested this patch with a toy implementation of kgraft for ARM and basic
usage of function and function_graph tracers
It doesn't show any problem with the ftrace selftests and the tests found
today in branch ftrace/testing-mystuff of linux-trace repository
(git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git)


change since v1:
 - changed the title and the commit log of the patch to make it more
   understandable

Jean-Jacques Hiblot (1):
  arm: ftrace: Adds support for CONFIG_DYNAMIC_FTRACE_WITH_REGS

 arch/arm/Kconfig               |  2 ++
 arch/arm/include/asm/ftrace.h  |  3 ++
 arch/arm/kernel/entry-common.S | 68 +++++++++++++++++++++++++++++++++++++++++-
 arch/arm/kernel/ftrace.c       | 34 +++++++++++++++++++++
 4 files changed, 106 insertions(+), 1 deletion(-)

-- 
2.1.3
