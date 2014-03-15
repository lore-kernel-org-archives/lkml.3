Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbaCOUCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 16:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317AbaCOUCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 16:02:09 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE instructions
Date: Sat, 15 Mar 2014 21:01:58 +0100
Message-Id: <1394913720-6466-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MS HCK test fails on 32-bit Windows 8.1 due to missing MOVAPS
instruction emulation, this series adds it and while at it,
it adds emulation of MOVAPD which is trivial to implement on
top of MOVAPS.

Igor Mammedov (2):
  KVM: x86 emulator: emulate MOVAPS
  KVM: x86 emulator: emulate MOVAPD

 arch/x86/kvm/emulate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
1.8.5.3

