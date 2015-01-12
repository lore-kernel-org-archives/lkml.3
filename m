Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbbALOy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:54:26 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50049 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbbALOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:54:24 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-0d-54b3e01c9f00
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] dt-bindings: Add Silicon Mitus vendor prefix
Date: Mon, 12 Jan 2015 15:54:11 +0100
Message-id: <1421074451-6961-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t/xK7oyDzaHGGx4a2kx/8g5Vov+NwtZ
	Lc69Wslo8fqFocXlXXPYLJZev8hkMWH6WhaL1r1H2B04PNbMW8Pocbmvl8lj5fIvbB6bVnWy
	efRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGj6knmApWsVXc/nmLqYHxIGsXIyeHhICJxKlV
	29khbDGJC/fWs3UxcnEICSxllHi67SszhNPHJPGhezNYFZuAscTm5UvAqkQE/jJKzLjYygyS
	YBYwlPj57g9YkbCArcSH6+fA4iwCqhILdjQygti8Am4Sb179Y4FYJydx8thk1gmM3AsYGVYx
	iqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihITOlx2Mi49ZHWIU4GBU4uGdILM5RIg1say4MvcQ
	owQHs5IIr2sZUIg3JbGyKrUoP76oNCe1+BAjEwenVAOjwSHFlx7P9FgFn7VIdkt0i07q2nQj
	tmDmdN7Zhp6Gf1fs3Hnn7kXLtdfD6xPaauPUenbmZj9v/+Qccz061zt5+oVyxU8rOCdO+buU
	d0vior0F1xRsv+lu3nTs8K8brOaln3uCNRfoK7ZVbhEzFVyp4FltdVv84nKO7bcabPbsDM2Z
	qhQ45c46JZbijERDLeai4kQAnFt5EfsBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add vendor prefix for Silicon Mitus. Currently there is binding for
sm5502 extcon driver ("siliconmitus,sm5502-muic").

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 75595c2b0a36..ebe1be28de75 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -143,6 +143,7 @@ schindler	Schindler
 seagate	Seagate Technology PLC
 sil	Silicon Image
 silabs	Silicon Laboratories
+siliconmitus	Silicon Mitus, Inc.
 simtek
 sii	Seiko Instruments, Inc.
 silergy	Silergy Corp.
-- 
1.9.1

