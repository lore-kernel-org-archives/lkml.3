Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbbAWRvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:51:10 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:48912 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbAWRvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:51:07 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86,earlyptink: use macros which are already defined
Date: Fri, 23 Jan 2015 23:50:51 +0600
Message-Id: <1422035451-18795-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0.rc1.275.g028c360
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to use macros which already defined. <linux/serial_reg.h> already
contains macros for initialization and work with serial port, but with another
names.

Alexander Kuleshov (2):
  x86/boot/early_serial: use macros which are already defined
  x86/kernel/early_printk: use macros which are already defined

 arch/x86/boot/boot.h                 |  1 +
 arch/x86/boot/compressed/misc.c      |  9 +++-----
 arch/x86/boot/compressed/misc.h      |  1 +
 arch/x86/boot/early_serial_console.c | 44 ++++++++++++------------------------
 arch/x86/boot/tty.c                  | 10 +++-----
 arch/x86/kernel/early_printk.c       | 40 +++++++++++---------------------
 6 files changed, 35 insertions(+), 70 deletions(-)

--
2.3.0.rc1.275.g028c360
