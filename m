Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaLCNlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:41:44 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45094 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaLCNll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:41:41 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 0/2] kvm: x86: final XSAVES bits
Date: Wed,  3 Dec 2014 14:40:28 +0100
Message-Id: <1417614030-1692-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The final thing to do, besides adding support for XSS != 0, is to set
CPUID(EAX=0xd,ECX=1).EBX to the size of the XSAVES area.

Paolo Bonzini (2):
  KVM: x86: use F() macro throughout cpuid.c
  KVM: x86: set CPUID(EAX=0xd,ECX=1).EBX correctly

 arch/x86/kvm/cpuid.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

-- 
1.8.3.1

