Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934473Ab3IDIm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:42:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39969 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934353Ab3IDIm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:42:56 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Rob Landley <rob@landley.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, <mtosatti@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH V2] Documentation/kvm: Update cpuid documentation for steal  time and pv eoi
Date: Wed,  4 Sep 2013 14:18:46 +0530
Message-Id: <1378284526-863-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <y>
References: <y>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090408-7182-0000-0000-0000084AE103
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 Changes in V2:
  Correction in the description of steal time and added msr info (Michael S Tsirkin)

 Documentation/virtual/kvm/cpuid.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 22ff659..6c4fb20 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -43,6 +43,16 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
 KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
                                    ||       || writing to msr 0x4b564d02
 ------------------------------------------------------------------------------
+KVM_FEATURE_STEAL_TIME             ||     5 || Steal time available at msr
+                                   ||       || 0x4b564d03. The feature is enabled
+                                   ||       || by guest when host has schedstat
+                                   ||       || or task delay accounting support.
+------------------------------------------------------------------------------
+KVM_FEATURE_PV_EOI                 ||     6 || overrides the generic EOI
+                                   ||       || implementation with a
+                                   ||       || paravirtualized version. Available
+                                   ||       || at msr 0x4b564d04.
+------------------------------------------------------------------------------
 KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
                                    ||       || before enabling paravirtualized
                                    ||       || spinlock support.
-- 
1.7.11.7

