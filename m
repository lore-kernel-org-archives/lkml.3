Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaDDCQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 22:16:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33711 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaDDCQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 22:16:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] ARM: mm: implement CONFIG_DEBUG_RODATA
Date: Thu,  3 Apr 2014 19:15:17 -0700
Message-Id: <1396577719-14786-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the next round of trying to implement RODATA. This series works
for the page tables, but I can't make ftrace work. I would love to know
what I should fix here. :)

Thanks to everyone who's been helping with this series!

-Kees

