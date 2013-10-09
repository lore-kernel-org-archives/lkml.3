Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab3JIGa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:30:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3JIGas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:30:48 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-70-5254f802b5be
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, kgene.kim@samsung.com
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v2 4/5] ARM: dts: exynos4x12: Device tree node definition for
 TMU on Exynos4x12
Date: Wed, 09 Oct 2013 08:29:53 +0200
Message-id: <1381300194-13134-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQV2mHyFBBg9fCVo0XA2x2DhjPavF
	/CPnWC3W7P/JZNF59gmzRe+Cq2wWbx5xW7x5uJnR4vKuOWwWn3uPMFrMOL+PyeJ24wo2izOn
	L7FaPHnYx2axfsZrFgd+j8V7XjJ5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXABbFJdNSmpO
	Zllqkb5dAlfG/PmHmQues1U0rL7C2sB4krWLkZNDQsBE4tbD+1C2mMSFe+vZuhi5OIQEpjNK
	nJq/DcrpYpKYsWsbE0gVm4CexOe7T8FsEYEMiVOXZjOBFDEL/GWWuD7tGAtIQlggUWLS6ufM
	IDaLgKrEx94DjCA2r4CbxKnFVxkh1slLPL3fxwZicwq4Sxy8844dYlszo8Sji5tYJjDyLmBk
	WMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHLDPpHYwrmywOMQowMGoxMP7gD8kSIg1say4
	MvcQowQHs5IIb95CoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZ
	Jg5OqQbG6MMa1tyMVzIMAm4wvT5/9Y3tGZ3tcWLMvV5Jhpofjbv15dQO6wtqeesfVYpIW/tB
	4lvka92n9heORIudTtrJuuRr9FHBZacKv698mVY8KWwfh7Jb6A4VhTkpqmci19+PCOHPnlf2
	sPcY87lQ1/TVe4on7v5w/9s7/povq76uC/f/tlRk35mpSizFGYmGWsxFxYkAGzDRXVQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TMU device tree node definition for Exynos4x12 family of SoCs.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

---
Changes for v2:
- None

 arch/arm/boot/dts/exynos4x12.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index ad531fe..64c0ece 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -176,4 +176,14 @@
 			};
 		};
 	};
+
+	tmu@100C0000 {
+		compatible = "samsung,exynos4412-tmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		reg = <0x100C0000 0x100>;
+		clocks = <&clock 383>;
+		clock-names = "tmu_apbif";
+		status = "disabled";
+	};
 };
-- 
1.7.10.4

