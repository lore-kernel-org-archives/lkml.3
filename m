Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaDHDRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 23:17:30 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42253 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbaDHDR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 23:17:28 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: mm: implement CONFIG_DEBUG_RODATA
Date: Mon,  7 Apr 2014 20:15:08 -0700
Message-Id: <1396926910-11227-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements CONFIG_DEBUG_RODATA, along with ftrace support. It is
intended to be used on top of Rabin Vincent's patch "arm: ftrace: work
with CONFIG_DEBUG_SET_MODULE_RONX", so that ftrace will work with both
config options.

Thanks!

-Kees

