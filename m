Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864Ab3ECJHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:07:39 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:65133 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3ECJHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:07:37 -0400
From: Daniel Baluta <dbaluta@ixiacom.com>
To: lguest@lists.ozlabs.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] lguest: rename i386_head.S
Date: Fri,  3 May 2013 12:07:19 +0300
Message-Id: <1367572039-6676-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 9a163ed8e0 (i386: move kernel) kernel/i386_head.S
was renamed to kernel/head_32.S. We do the same for lguest/i386_head.S.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
---
 arch/x86/lguest/{i386_head.S => head_32.S} |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename arch/x86/lguest/{i386_head.S => head_32.S} (100%)

diff --git a/arch/x86/lguest/i386_head.S b/arch/x86/lguest/head_32.S
similarity index 100%
rename from arch/x86/lguest/i386_head.S
rename to arch/x86/lguest/head_32.S
-- 
1.7.5.4

