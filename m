Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3FJTd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:33:59 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57581 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3FJTd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:33:57 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/2] kvm/mips: ABI fix for 3.10
Date: Mon, 10 Jun 2013 12:33:46 -0700
Message-Id: <1370892828-21676-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

As requested by Gleb Natapov, we need to define and use KVM_REG_MIPS
when using the GET_ONE_REG/SET_ONE_REG ioctl.  Since this is part of
the MIPS kvm support that is new in 3.10, it should be merged before a
bad ABI leaks out into an 'official' kernel release.

David Daney (2):
  kvm: Add definition of KVM_REG_MIPS
  mips/kvm: Use KVM_REG_MIPS and proper size indicators for *_ONE_REG

 arch/mips/include/uapi/asm/kvm.h | 81 +++++++++++++++++++--------------------
 arch/mips/kvm/kvm_mips.c         | 83 ++++++++++++++++++++++++++--------------
 include/uapi/linux/kvm.h         |  1 +
 3 files changed, 94 insertions(+), 71 deletions(-)

-- 
1.7.11.7

