Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3GFMPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 08:15:19 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41162 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3GFMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 08:15:17 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Trivial sparse acquire/release annotations
Date: Sat,  6 Jul 2013 17:41:23 +0530
Message-Id: <1373112686-28501-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.733.gf8abaeb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So, I was looking at sparse this lazy Saturday afternoon.  Thought I
might as well clean up a few obvious warnings while I'm there.

Thanks.

Ramkumar Ramachandra (3):
  nfs: add lock annotations to squelch sparse warnings
  apic: add lock annotations to squelch sparse warnings
  irq: add lock annotation to squelch a sparse warning

 arch/x86/kernel/apic/io_apic.c | 2 ++
 fs/nfs/client.c                | 4 ++++
 kernel/irq/irqdesc.c           | 1 +
 3 files changed, 7 insertions(+)

-- 
1.8.3.2.733.gf8abaeb

