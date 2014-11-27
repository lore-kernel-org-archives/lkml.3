Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaK0LVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:21:19 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64229 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbaK0LVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:14 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-11-547709279735
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 2/7] regulator: dt-bindings: Document the ena-gpios property
Date: Thu, 27 Nov 2014 12:20:48 +0100
Message-id: <1417087253-12306-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xK7rqnOUhBq+OSFpsnLGe1WLqwyds
	FvOPnGO1eP3C0KL/8Wtmi7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7vmsNmMeP8PiaLtUfusjvw
	eOycdZfdY9OqTjaPO9f2sHlsXlLv0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBmbn91nL/jJ
	UdHz3qaB8Q57FyMnh4SAicSPlRtZIWwxiQv31rN1MXJxCAksZZT4f3gtI4TTxyTReX0ZI0gV
	m4CxxOblS9hAbBGBFYwSx28ogtjMAuuZJB5scwKxhQX8JeZv+sIEYrMIqEpMubkMbAOvgLvE
	sv+TGCG2yUmcPDYZLM4p4CGx99ZtFhBbCKhmz6s7LBMYeRcwMqxiFE0tTS4oTkrPNdQrTswt
	Ls1L10vOz93ECAnGLzsYFx+zOsQowMGoxMOb8LgsRIg1say4MvcQowQHs5IILxdjeYgQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGRn8DQ/EUPd621OMB6nOli/wn58ywbVjxtHPF8XNr97Gdm/fX
	qfBErm/I9UTXyYo8uYuStY00fD8tiGwTLLy0Ive5/HmnhStyOvnqEubfv9i47oLf3bxbHq7f
	1hQ+NVmzdK22eKjhP6XdC+pbb1hJn9A+1fUz78Qd1kizBI9+bzfjK2a88nfSlViKMxINtZiL
	ihMB6U/EjiQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document new properties for regulators (ena-gpios and
ena-gpio-open-drain) for enabling control over GPIO.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/regulator/regulator.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 4e7ed762b3bb..dad57b3badc7 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -30,6 +30,10 @@ Optional properties:
 	- regulator-off-in-suspend: regulator should be off in suspend state.
 	- regulator-suspend-microvolt: regulator should be set to this voltage
 	  in suspend.
+- ena-gpios: GPIO to use for enable control. Actual implementation depends
+  on regulator driver. The bindings documentation for given driver describes
+  which regulator actually supports it.
+- ena-gpio-open-drain: GPIO is open drain type.
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
-- 
1.9.1

