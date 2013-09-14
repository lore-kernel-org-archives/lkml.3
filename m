Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab3INMLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:11:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab3INMLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:11:46 -0400
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: catalin.marinas@arm.com, christoffer.dall@linaro.org, gleb@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, pbonzini@redhat.com, linux@arm.linux.org.uk,
        will.deacon@arm.com
Subject: [PATCH 0/3] KVM_MAX_VCPUS related changes
Date: Sat, 14 Sep 2013 14:10:53 +0200
Message-Id: <1379160656-28050-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Jones (3):
  arm: kvm: clamp NR_VCPUS to MAX_VCPUS
  arm32: kvm: rename CONFIG_KVM_ARM_MAX_VCPUS
  aarch64: kvm: introduce CONFIG_KVM_MAX_VCPUS

 arch/arm/include/asm/kvm_host.h   |  4 ++--
 arch/arm/kvm/Kconfig              |  8 ++++----
 arch/arm/kvm/arm.c                |  2 +-
 arch/arm64/include/asm/kvm_host.h |  7 ++++++-
 arch/arm64/kvm/Kconfig            | 11 +++++++++++
 5 files changed, 24 insertions(+), 8 deletions(-)

-- 
1.8.1.4

