Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3ILM2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:28:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52741 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3ILM2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:28:39 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 1/2] DT: add a vendor prefix for Dialog Semiconductor
Date: Thu, 12 Sep 2013 14:28:34 +0200
Message-Id: <1378988915-10539-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378988915-10539-1-git-send-email-g.liakhovetski@gmx.de>
References: <1378988915-10539-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:lQ9xCzQmfo/j1KD3NFB8I+9R/RTl7eUnyN9hLI4VVB3
 cHB+7hiXAZkLjM6mKMwqmyaukJVU97X0iMh7jQ97hDoyOBDqjW
 4GsxzgVhDGajD+12QvvLFyv2N55AQzINEDFh51SkwlYOCbwWjD
 M/VJOwn3L7SX05DUWekplVY0zSrIVnj66H7SFmhuTCR3/LTZnI
 Hwf4FZAeOGvMytKgHwNAOcDChEoPhQnSDE2F2c2bad5N2fStSF
 Y8Mv84r1GoCGnx7TAlMcZmVJn0EX7Y9pzVuGZmM2+cYBH2FN2F
 WuEnX88mGBO3qYK2wi3+JoaA/Qy6k6i+Fp2vXBESFH1KeMOVur
 I6LSUFQVKjuut0U9oDjCZwypy/bTtC1es+Rvm6xXuox48vDcDV
 vTOngqviqSYSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a commonly used "diasemi" prefix for Dialog Semiconductor PLC.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 2956800..f8d5a75 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -22,6 +22,7 @@ cortina	Cortina Systems, Inc.
 dallas	Maxim Integrated Products (formerly Dallas Semiconductor)
 davicom	DAVICOM Semiconductor, Inc.
 denx	Denx Software Engineering
+diasemi	Dialog Semiconductor
 emmicro	EM Microelectronic
 epson	Seiko Epson Corp.
 est	ESTeem Wireless Modems
-- 
1.7.2.5

