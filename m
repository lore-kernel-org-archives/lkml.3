Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030432Ab3FUDYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:24:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52216 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030247Ab3FUDY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:24:28 -0400
X-AuditID: cbfee691-b7fef6d000002d62-91-51c3c76a8070
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
Subject: [PATCH V9 3/4] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Fri, 21 Jun 2013 12:24:26 +0900
Message-id: <002301ce6e2e$d4fd8ae0$7ef8a0a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5uLtB/wueZ67I3TJy+sAyVxnOwXw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t8zY92s44cDDQ5vUrRo/r+d1eLvpGPs
	FkuaMixeHtK0ODD7IavFqzMb2SwuL7zEavH9hqlF74KrbBabHl9jtbi8aw6bxdl5x9ksZpzf
	x2SxceovRov2S8oWK5q2Mlosvric2WL9jNcsFrtXLmGxODZjCaPF0wdNTA6iHmvmrWH0+P1r
	EqNH35SrbB5PNl1k9FiwqdTjzrU9bB6bl9R7nJ+xkNHj+45eoIItqxg9fr7U8Xj6Yy+zx+dN
	cgG8UVw2Kak5mWWpRfp2CVwZN0/3sRTc56941J3ewLiHp4uRk0NCwERi75YmNghbTOLCvfVA
	NheHkMAyRonHz+YywRT9vH+NHSIxnVFi1o33jBDOL0aJuVcusYBUsQmoSXz5cpgdxBYR8Je4
	drWVBaSIWaCDTWLTvE2sIAlhgXCJqdu/AHVzcLAIqEo0TbIFCfMKWEpcvfCRHcIWlPgx+R7Y
	TGYBLYn1O48zQdjyEpvXvGWGuEhBYsfZ14wQu/Qkfn/4zgpRIyKx78U7RoiaFxwSPZ0qIDaL
	gIDEt8mHWEDWSgjISmw6ADVGUuLgihssExjFZiHZPAvJ5llINs9CsmEBI8sqRtHUguSC4qT0
	IlO94sTc4tK8dL3k/NxNjJDUMnEH4/0D1ocYk4HWT2SWEk3OB6amvJJ4Q2MzIwtTE1NjI3NL
	M9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw9hbNsO5riPz+8erV11m3NR1z
	DJZEneyQuVfAflqlolS0W/PruWxmPuFIi+D6kNB1SXmd55geG6p/EI4qrZCwyy1fVXFL3WRb
	46SWR7xrHvPyaa+WE+J0uzVXOaNjzgl3k7ufjkfaLsz+OvUEt78sg3+E3XyN/+pZZ81nX3p4
	/0TXBOv7Ee+UWIozEg21mIuKEwFdrKipQwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42I5/e+xoG7W8cOBBocfS1k0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF+xmsWi90rl7BYHJuxhNHi6YMmJgdRjzXz1jB6/P41
	idGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9YyOjxfUcvUMGWVYweP1/qeDz9sZfZ4/Mm
	uQDeqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	d5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGTdP97EU3OeveNSd3sC4
	h6eLkZNDQsBE4uf9a+wQtpjEhXvr2boYuTiEBKYzSsy68Z4RwvnFKDH3yiUWkCo2ATWJL18O
	g3WICPhLXLvaygJSxCzQwSaxad4mVpCEsEC4xNTtX4C6OThYBFQlmibZgoR5BSwlrl74yA5h
	C0r8mHwPbCazgJbE+p3HmSBseYnNa94yQ1ykILHj7GtGiF16Er8/fGeFqBGR2PfiHeMERoFZ
	SEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnLqeSe1gXNlgcYhR
	gINRiYd3hcrhQCHWxLLiytxDjBIczEoivGITgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqc
	D0yreSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA2H30kiaj
	vvTfq4f98p5YvfsUWj/Zvd1ATPotzwYutxsnJW5EaW84e+O56g42g1+TC7s4l5b2L2Hfadkd
	LZ75o+noXv4ZG/iaT01/IThZTdZI/hZroWzXFWeles+jXhHiymEvXqtkveOSMKlN5t4iv/mu
	4JKGf/0rNmQlvzXapBR1767/+g9nlViKMxINtZiLihMBAMeXzKEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5440 has two PCIe controllers which can be used as root complex
for PCIe interface.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/exynos5440.dtsi |   38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 03d40c0..1ac4f5b 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -230,4 +230,42 @@
 		clocks = <&clock 24>;
 		clock-names = "usbhost";
 	};
+
+	pcie@290000 {
+		compatible = "samsung,exynos5440-pcie", "snps,dw-pcie";
+		reg = <0x290000 0x1000
+			0x270000 0x1000
+			0x271000 0x40>;
+		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
+		clocks = <&clock 28>, <&clock 27>;
+		clock-names = "pcie", "pcie_bus";
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00001000   /* configuration space */
+			  0x81000000 0 0	  0x40001000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0x40011000 0x40011000 0 0x1ffef000>; /* non-prefetchable memory */
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 0 0>;
+		interrupt-map = <0x0 0 &gic 53>;
+	};
+
+	pcie@2a0000 {
+		compatible = "samsung,exynos5440-pcie", "snps,dw-pcie";
+		reg = <0x2a0000 0x1000
+			0x272000 0x1000
+			0x271040 0x40>;
+		interrupts = <0 23 0>, <0 24 0>, <0 25 0>;
+		clocks = <&clock 29>, <&clock 27>;
+		clock-names = "pcie", "pcie_bus";
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00001000   /* configuration space */
+			  0x81000000 0 0	  0x60001000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0x60011000 0x60011000 0 0x1ffef000>; /* non-prefetchable memory */
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 0 0>;
+		interrupt-map = <0x0 0 &gic 56>;
+	};
 };
-- 
1.7.10.4


