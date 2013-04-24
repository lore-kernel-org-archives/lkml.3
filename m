Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3DXMIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:08:34 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55646 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3DXMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:08:33 -0400
X-Nat-Received: from [202.181.97.72]:61691 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1366805311.6037
To: linux-kernel@vger.kernel.org
Subject: [linux-next-20130422] Bug in bootup code or debug code?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 24 Apr 2013 21:08:27 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24042013 #9886847, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

linux-next-20130422 does not boot when built with CONFIG_DEBUG_SLAB=y &&
CONFIG_DEBUG_SPINLOCK=y && CONFIG_DEBUG_PAGEALLOC=y .

It hangs (with CPU#0 spinning) immediately after printing

  Decompressing Linux... Parsing ELF... done.
  Booting the kernel.

lines.

Config is at http://I-love.SAKURA.ne.jp/tmp/config-3.9-rc8-next-20130422 .

Any clue before starting bisection?

Regards.
