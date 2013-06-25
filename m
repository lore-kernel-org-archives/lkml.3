Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3FYHHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:07:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54120 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3FYHHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:07:10 -0400
Date: Tue, 25 Jun 2013 09:07:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH] regulator: max8973: fix a typo in documentation
Message-ID: <Pine.LNX.4.64.1306250905050.30321@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:4+Vj/UTu+ZYpTVlcaCxurD0oHt5xCkOWpQSFWXTvNLZ
 mFfYLdPg9tQPoGU9OWq2EXv8CqDLH6zfsSS6OtuHZ7h6LcwTIa
 f5XNYsdPWZQAzL/UAJz21zNCAXGhtHM6CXu5tg/Bludme3VDaE
 BiOLevuGe6uy7jP0WALemQ5xYUNuo3S/XnThiJLxl3gn5Zgdxr
 p5t99SheCQ6pnH1tDyziEOK18drQVEXfm0S1jKq0tDLsWZbT7G
 vSIBDrnmBw7dweRzNWYEmE084l4l4Jtfjno3Vc6NTKiO/MAlm/
 uyuEPP/aFjq77pLLA6phQgnA0yIghJWPgzI+mD5S5/elA7UzUO
 jkFTS+sPgnc0iHe/6j4tb1jpwxlhj/P/fpHcoNLz0aN5+kL4gG
 OL+mO+OI5XquA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a s/maxium/maxim/ typo in DT binding documentation.

Reported-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

Mark, if still possible, feel free to merge this with the original patch.
Thanks
Guennadi

 .../bindings/regulator/max8973-regulator.txt       |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/max8973-regulator.txt b/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
index 8d38ab2..4f15d8a 100644
--- a/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/max8973-regulator.txt
@@ -2,7 +2,7 @@
 
 Required properties:
 
-- compatible:	must be "maxium,max8973"
+- compatible:	must be "maxim,max8973"
 - reg:		the i2c slave address of the regulator. It should be 0x1b.
 
 Any standard regulator properties can be used to configure the single max8973
@@ -11,7 +11,7 @@ DCDC.
 Example:
 
 	max8973@1b {
-		compatible = "maxium,max8973";
+		compatible = "maxim,max8973";
 		reg = <0x1b>;
 
 		regulator-min-microvolt = <935000>;
-- 
1.7.2.5

