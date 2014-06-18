Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966880AbaFROUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:20:14 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:9694 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbaFROUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:20:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4BACOfoVOERCABjGdsb2JhbABarlABAQaDXo4Gh0SBChYPAQEBJzyFA4oTxxuFXheFYokTHYQtBIo5pyc
X-IPAS-Result: Au4BACOfoVOERCABjGdsb2JhbABarlABAQaDXo4Gh0SBChYPAQEBJzyFA4oTxxuFXheFYokTHYQtBIo5pyc
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034676"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 0/5] x86: Tests for recent emulator bugs
Date: Wed, 18 Jun 2014 17:19:49 +0300
Message-Id: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set checks recent emulator bugs as well as monitor-mwait emulation
in real-mode.

Nadav Amit (5):
  x86: Testing nop instruction on 64-bit
  x86: test xadd with two identical operands
  x86: Test btcq with operand larger than 64
  x86: check cmov instruction on 64-bit
  x86: Test monitor and mwait on real-mode

 x86/emulator.c | 30 ++++++++++++++++++++++++++++--
 x86/realmode.c | 20 ++++++++++++++++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

-- 
1.9.1

