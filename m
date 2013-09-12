Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3ILHYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:24:37 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38881 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab3ILHYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:24:35 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Rob Landley <rob@landley.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, <mtosatti@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH V3] Documentation/kvm: Update cpuid documentation for steal  time and pv eoi
Date: Thu, 12 Sep 2013 13:00:11 +0530
Message-Id: <1378971011-25774-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <y>
References: <y>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091207-0320-0000-0000-000000F9794C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Michael S Tsirkin for rewriting the description and suggestions.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---

 Changes in V3:
  Keep msr specific info only as suggested by Michael. 

 Documentation/virtual/kvm/cpuid.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
index 22ff659..3c65feb 100644
--- a/Documentation/virtual/kvm/cpuid.txt
+++ b/Documentation/virtual/kvm/cpuid.txt
@@ -43,6 +43,13 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
 KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
                                    ||       || writing to msr 0x4b564d02
 ------------------------------------------------------------------------------
+KVM_FEATURE_STEAL_TIME             ||     5 || steal time can be enabled by
+                                   ||       || writing to msr 0x4b564d03.
+------------------------------------------------------------------------------
+KVM_FEATURE_PV_EOI                 ||     6 || paravirtualized end of interrupt
+                                   ||       || handler can be enabled by writing
+                                   ||       || to msr 0x4b564d04.
+------------------------------------------------------------------------------
 KVM_FEATURE_PV_UNHALT              ||     7 || guest checks this feature bit
                                    ||       || before enabling paravirtualized
                                    ||       || spinlock support.
-- 
1.7.11.7

