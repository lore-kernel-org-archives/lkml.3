Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaCOUDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 16:03:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbaCOUDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 16:03:44 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests 0/2] test MOVAPS and MOVAPD SSE instructions
Date: Sat, 15 Mar 2014 21:03:36 +0100
Message-Id: <1394913818-6616-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds checks for MOVAPS and MOVAPD SSE instructions.
It's used by MS HCK test on 32-bit Windows 8.1

Igor Mammedov (2):
  emulator: movaps
  emulator: movapd

 x86/emulator.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

-- 
1.8.5.3

