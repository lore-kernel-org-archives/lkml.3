Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab3FTMqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:46:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57560 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab3FTMp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:45:59 -0400
X-AuditID: cbfee691-b7fef6d000002d62-0f-51c2f985996d
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
Subject: [PATCH V8 4/4] ARM: dts: Add pcie controller node for
 exynos5440-ssdk5440
Date: Thu, 20 Jun 2013 21:45:57 +0900
Message-id: <00de01ce6db4$1c2b8c80$5482a580$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5ttBa3LEIYDL6pTzmoT1Hufy4Hww==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t8zQ93Wn4cCDe61GFk0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF+xmsWi90rl7BYHJuxhNHi6YMmJgdRjzXz1jB6/P41
	idGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9YyOjxfUcvUMGWVYweP1/qeDz9sZfZ4/Mm
	uQDeKC6blNSczLLUIn27BK6MjRs/MBU85axYsOY6UwPjf/YuRk4OCQETiXetO6FsMYkL99az
	dTFycQgJLGOUePR6EVzRq9M3mSASixglZi39ywzh/GKUmP1lFxNIFZuAmsSXL4fBOkQE/CWu
	XW1lASliFuhgk9g0bxMrSEJYIETixYQ7bCA2i4CqxMMnL5lBbF4BS4kF7ZMZIWxBiR+T77GA
	2MwCWhLrdx5ngrDlJTavecsMcZKCxI6zrxkhlulJHNp9jBmiRkRi34t3jCCLJQTecEjsP7CA
	FWKZgMS3yYeAhnIAJWQlNh2AmiMpcXDFDZYJjGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFx
	UnqRqV5xYm5xaV66XnJ+7iZGSIKZuIPx/gHrQ4zJQOsnMkuJJucDE1ReSbyhsZmRhamJqbGR
	uaUZacJK4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhibu9ZOsfbYV2a6V32FlRTn
	+7e2qq52zpcf3ZVfwmG5UWVnydnKljN9Vr1nlBdKe1qa+Oxx3nHmSsxMy3iRN2leex8seGzD
	9OiykcyD/PqWmz1z/ltIXPhW2j2t9P3VFbMq/Xy2KfQFm4XMOFO+fraB2beFEaJzrzQlMEum
	vS3s19RZ/MdneZsSS3FGoqEWc1FxIgAG1UiaRgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsVy+t9jAd3Wn4cCDXZM1rZo/r+d1eLvpGPs
	FkuaMixeHtK0ODD7IavFqzMb2SwuL7zEavH9hqlF74KrbBabHl9jtbi8aw6bxdl5x9ksZpzf
	x2SxceovRov2S8oWK5q2Mlosvric2WL9jNcsFrtXLmGxODZjCaPF0wdNTA6iHmvmrWH0+P1r
	EqNH35SrbB5PNl1k9FiwqdTjzrU9bB6bl9R7nJ+xkNHj+45eoIItqxg9fr7U8Xj6Yy+zx+dN
	cgG8UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	7yoplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMzZu/MBU8JSzYsGa60wN
	jP/Zuxg5OSQETCRenb7JBGGLSVy4t56ti5GLQ0hgEaPErKV/mSGcX4wSs7/sAqtiE1CT+PLl
	MFi3iIC/xLWrrSwgRcwCHWwSm+ZtYgVJCAuESLyYcIcNxGYRUJV4+OQlM4jNK2ApsaB9MiOE
	LSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmSFOUpDYcfY1I8QyPYlDu48xQ9SISOx78Y5xAqPA
	LCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE5fz6R2MK5ssDjE
	KMDBqMTDq3H5YKAQa2JZcWXuIUYJDmYlEd7UOYcChXhTEiurUovy44tKc1KLDzEmA306kVlK
	NDkfmFrzSuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGRe+Kq
	zu0h6S+Ydj7aO5mJh+P59sc2Nn+Pda+RKTBm3/fy1bG/5tIrjrP/Uzd5WCd2aFNVpKsih+KH
	/PBVvFKV8tM7DzXNq4xZuaBj5obrOffam4q7vaT6psoa84axJlVYslmaZ+wS3K7VF/PxEVcO
	N++GK9dez5tVd8Xyzn3WLIfrUxKFwq8psRRnJBpqMRcVJwIAmwg1FaMDAAA=
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
index 68d05e9..de31f0c 100644
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


