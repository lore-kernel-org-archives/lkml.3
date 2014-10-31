Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbaJaQFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:05:44 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52171 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759374AbaJaQFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:05:07 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 2/3] arm64: Create link to include/dt-bindings to enable C preprocessor use.
Date: Fri, 31 Oct 2014 16:04:19 +0000
Message-Id: <1414771460-7340-3-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414771460-7340-1-git-send-email-Liviu.Dudau@arm.com>
References: <1414771460-7340-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT files used in the compilation phase can be preprocessed by the C
preprocessor. This requires an include/dt-bindings directory to be
present in the arch/arm64/boot/dts directory.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 arch/arm64/boot/dts/include/dt-bindings | 1 +
 1 file changed, 1 insertion(+)
 create mode 120000 arch/arm64/boot/dts/include/dt-bindings

diff --git a/arch/arm64/boot/dts/include/dt-bindings b/arch/arm64/boot/dts/include/dt-bindings
new file mode 120000
index 0000000..08c00e4
--- /dev/null
+++ b/arch/arm64/boot/dts/include/dt-bindings
@@ -0,0 +1 @@
+../../../../../include/dt-bindings
\ No newline at end of file
-- 
2.1.2

