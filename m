Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbbASJEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:04:23 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33105 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbASJEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:04:20 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86: earlyprintk cleanup
Date: Mon, 19 Jan 2015 15:04:14 +0600
Message-Id: <1421658254-22042-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0.rc0.44.ga94655d.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches remove unused macro definitions from 
early_serial_console and early_printk x86 code.

Alexander Kuleshov (2):
  x86/early_serial_console: remove unused definitions
  x86/early_printk: remove unused definitions

 arch/x86/boot/early_serial_console.c | 5 -----
 arch/x86/kernel/early_printk.c       | 3 ---
 2 files changed, 8 deletions(-)

-- 
2.3.0.rc0.44.ga94655d.dirty

