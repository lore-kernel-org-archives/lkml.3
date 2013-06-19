Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab3FSBmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:42:19 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46056 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab3FSBmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:42:17 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linux-doc@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Rob Landley <rob@landley.net>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kvm api doc: fix section numbers
Date: Wed, 19 Jun 2013 11:42:07 +1000
Message-Id: <1371606127-1192-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 Documentation/virtual/kvm/api.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 5f91eda..6365fef 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2261,7 +2261,7 @@ return indicates the attribute is implemented.  It does not necessarily
 indicate that the attribute can be read or written in the device's
 current state.  "addr" is ignored.
 
-4.77 KVM_ARM_VCPU_INIT
+4.82 KVM_ARM_VCPU_INIT
 
 Capability: basic
 Architectures: arm
@@ -2285,7 +2285,7 @@ Possible features:
 	  Depends on KVM_CAP_ARM_PSCI.
 
 
-4.78 KVM_GET_REG_LIST
+4.83 KVM_GET_REG_LIST
 
 Capability: basic
 Architectures: arm
@@ -2305,7 +2305,7 @@ This ioctl returns the guest registers that are supported for the
 KVM_GET_ONE_REG/KVM_SET_ONE_REG calls.
 
 
-4.80 KVM_ARM_SET_DEVICE_ADDR
+4.84 KVM_ARM_SET_DEVICE_ADDR
 
 Capability: KVM_CAP_ARM_SET_DEVICE_ADDR
 Architectures: arm
@@ -2342,7 +2342,7 @@ and distributor interface, the ioctl must be called after calling
 KVM_CREATE_IRQCHIP, but before calling KVM_RUN on any of the VCPUs.  Calling
 this ioctl twice for any of the base addresses will return -EEXIST.
 
-4.82 KVM_PPC_RTAS_DEFINE_TOKEN
+4.85 KVM_PPC_RTAS_DEFINE_TOKEN
 
 Capability: KVM_CAP_PPC_RTAS
 Architectures: ppc
-- 
1.7.10.4

