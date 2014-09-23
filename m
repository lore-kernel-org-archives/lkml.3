Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaIWNxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:53:05 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:37782 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbaIWNxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:53:01 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH] DT: mfd: pm8xxx: Add new compatible string
Date: Tue, 23 Sep 2014 16:52:40 +0300
Message-Id: <1411480360-18091-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc driver now supports PM8941 PMIC device, reflect this
in the binding document.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 .../devicetree/bindings/mfd/qcom,pm8xxx.txt        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
index 03518dc..f24f334 100644
--- a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
+++ b/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
@@ -61,6 +61,7 @@ The below bindings specify the set of valid subnodes.
 	Definition: must be one of:
 		    "qcom,pm8058-rtc"
 		    "qcom,pm8921-rtc"
+		    "qcom,pm8941-rtc"
 
 - reg:
 	Usage: required
-- 
1.7.0.4

