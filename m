Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423268Ab3FUH0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:26:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44125 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965269Ab3FUH0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:26:17 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-61-51c400163fab
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V10 4/4] ARM: dts: Add pcie controller node for
 exynos5440-ssdk5440
Date: Fri, 21 Jun 2013 16:26:14 +0900
Message-id: <003d01ce6e50$9c925d80$d5b71880$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5uUJutiNQHe8evRMabpgjRnC31hw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t8zQ10xhiOBBq92WFs0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF+xmsWi90rl7BYHJuxhNHi6YMmJgdRjzXz1jB6/P41
	idGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9YyOjxfUcvUMGWVYweP1/qeDz9sZfZ4/Mm
	uQDeKC6blNSczLLUIn27BK6MzR/2sxU85ax4+XQtawPjf/YuRk4OCQETiWU3TjFB2GISF+6t
	Z+ti5OIQEljGKPF88z3WLkYOsKIFUxIg4osYJa6c/8UK4fxilPh27SojSDebgJrEly+HwaaK
	CPhLXLvaygJSxCzQwSaxad4mVpCEsECoxLHzx8GKWARUJTb9fwVm8wpYSuyd0ckIYQtK/Jh8
	jwXEZhbQkli/8zgThC0vsXnNW2aIUxUkdpx9zQhynYiAnsTJe7wQJSIS+168YwTZKyHwhkNi
	4+luqF0CEt8mH2KB+EZWYtMBqDGSEgdX3GCZwCg2C8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcU
	J6UXGeoVJ+YWl+al6yXn525ihCSX3h2Mtw9YH2JMBlo/kVlKNDkfmJzySuINjc2MLExNTI2N
	zC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBo99V2vsGXYykVZjyRy79G
	Jhe29/tr5/Sf45zE0X/adXXkMR6ByUe7Nr1QqZp28MDC6jvRCyZeSS7cFXfmNVNpQcPvACm9
	6eurPb+ty58/VbPjgqnDTX2LHQU/buWlCB1Nv3BlLZdUukZq5nGXnjDfHr90Y+5DT8VVucut
	H3xkmupRc+7rRwclluKMREMt5qLiRACtGmG1RAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42I5/e+xgK4Yw5FAg5l/TCya/29ntfg76Ri7
	xZKmDIuXhzQtDsx+yGrx6sxGNovLCy+xWny/YWrRu+Aqm8Wmx9dYLS7vmsNmcXbecTaLGef3
	MVlsnPqL0aL9krLFiqatjBaLLy5ntlg/4zWLxe6VS1gsjs1Ywmjx9EETk4Oox5p5axg9fv+a
	xOjRN+Uqm8eTTRcZPRZsKvW4c20Pm8fmJfUe52csZPT4vqMXqGDLKkaPny91PJ7+2Mvs8XmT
	XABvVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	u0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjM0f9rMVPOWsePl0LWsD
	43/2LkYODgkBE4kFUxK6GDmBTDGJC/fWs3UxcnEICSxilLhy/hcrhPOLUeLbtauMIFVsAmoS
	X74cZgexRQT8Ja5dbWUBKWIW6GCT2DRvEytIQlggVOLY+eNgRSwCqhKb/r8Cs3kFLCX2zuhk
	hLAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zxEkKEjvOvmYEuVREQE/i5D1eiBIRiX0v3jFO
	YBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwanrmfQOxlUN
	FocYBTgYlXh4A5QOBwqxJpYVV+YeYpTgYFYS4Q2+AxTiTUmsrEotyo8vKs1JLT7EmAz06ERm
	KdHkfGBazSuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRlV+
	QY73FSopNtI8vuvK3u65ZjDhqlFWDcf9Pwc5j53RnuW/unSXwKO0CI3tfpphyduCy9zYj36x
	vxVaz2cgoeHmF7Od3+39AwmXhpPyW+d3eJk7lQU09q18FmX1M2zFYa63Jk1ThJ3X627Vkkln
	in8uW61iM+3D/sVhZd/6mwV/7jm2SGuJEktxRqKhFnNRcSIAHg7z9KEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pcie controller node for exynos5440-ssdk5440,
and also adds a phandle for pin controller node.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/exynos5440-ssdk5440.dts |    8 ++++++++
 arch/arm/boot/dts/exynos5440.dtsi         |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
index f32cd77..ede7727 100644
--- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
+++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
@@ -65,4 +65,12 @@
 			clock-frequency = <50000000>;
 		};
 	};
+
+	pcie@290000 {
+		reset-gpio = <&pin_ctrl 5 0>;
+	};
+
+	pcie@2a0000 {
+		reset-gpio = <&pin_ctrl 22 0>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 1ac4f5b..ff7f5d8 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -126,7 +126,7 @@
 		clock-names = "spi", "spi_busclk0";
 	};
 
-	pinctrl {
+	pin_ctrl: pinctrl {
 		compatible = "samsung,exynos5440-pinctrl";
 		reg = <0xE0000 0x1000>;
 		interrupts = <0 37 0>, <0 38 0>, <0 39 0>, <0 40 0>,
-- 
1.7.10.4


