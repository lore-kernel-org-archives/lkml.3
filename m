Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaA3OTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:19:40 -0500
Received: from gloria.sntech.de ([95.129.55.99]:56411 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaA3OTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:19:38 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: add vendor-prefix for neonode
Date: Thu, 30 Jan 2014 15:18:46 +0100
Message-ID: <2809570.RstiYk4HG8@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bqreaders.com>

Neonode Inc. is the Manufacturer of the zforce infraread touchscreens
used in a lot of ebook readers and supported by the zforce_ts driver.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bqreaders.com>
---
Dmitry, the input maintainer, didn't want to carry the vendor-prefix
addition [0], therefore add it separately.

[0] http://permalink.gmane.org/gmane.linux.kernel.input/33887

 Documentation/devicetree/bindings/vendor-prefixes.txt |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index edbb8d8..32a60a9 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -47,6 +47,7 @@ maxim	Maxim Integrated Products
 microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
 national	National Semiconductor
+neonode		Neonode Inc.
 nintendo	Nintendo
 nvidia	NVIDIA
 nxp	NXP Semiconductors
-- 
1.7.10.4


