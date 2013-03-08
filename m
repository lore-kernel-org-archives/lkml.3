Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3CHKdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:33:06 -0500
Received: from intranet.asianux.com ([58.214.24.6]:58251 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3CHKdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:33:04 -0500
X-Spam-Score: -100.8
Message-ID: <5139BE48.4010602@asianux.com>
Date: Fri, 08 Mar 2013 18:32:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>, dhowells@redhat.com
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM:kernel: beautify code: correct the tabs count for '}'
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  the '}' for 'function' and 'for', need be with correct tabs count

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm/kernel/kprobes-common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 18a7628..17faa7c 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -574,5 +574,5 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		default:
 			return INSN_REJECTED;
 		}
-		}
 	}
+}
-- 
1.7.7.6
