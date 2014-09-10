Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbaIJGAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:00:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51779 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaIJGAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:00:39 -0400
X-AuditID: cbfee68e-f79536d000000fd1-f6-540fe90592fd
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, s.nawrocki@samsung.com,
        mturquette@linaro.org, Chander Kashyap <k.chander@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [PATCH] clk: samsung: exynos5260: fix typo in clock name
Date: Wed, 10 Sep 2014 11:26:05 +0530
Message-id: <1410328565-25122-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkTpf1JX+IwbrpQhaP1yxmsli1YQmL
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLJ5OuMhmcfhNO6vFql1/GB04PXbOusvucefaHjaPzUvq
	Pfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvjzJGdrAWXOSp+PlnO2MB4kL2LkYNDQsBEouNn
	ahcjJ5ApJnHh3no2EFtIYCmjxPcuBYi4iUT/0TdA5VxA8emMEjMPbGWDcCYwSezf+JgdpIpN
	QFfiyfu5zCC2iEC2RP/t1SwgRcwC24AmbW8CKxIWcJTY8rCLCcRmEVCV+NfaANbAK+AhcbVh
	KRvERQoScybZgPRKCHSzS5z4MJcdol5A4tvkQywQNbISmw4wQ1wnKXFwxQ2WCYyCCxgZVjGK
	phYkFxQnpRcZ6RUn5haX5qXrJefnbmIEhvHpf8/6djDePGB9iFGAg1GJh1eglj9EiDWxrLgy
	9xCjKdCGicxSosn5wGjJK4k3NDYzsjA1MTU2Mrc0UxLnTZD6GSwkkJ5YkpqdmlqQWhRfVJqT
	WnyIkYmDU6qB0X/Tlyv3OLJP9L2IqTSdcePfw3+sJz+xadb++6Ro5X8uqtgpqpYjuujCSa7G
	Ry6nQvfnJq47+/SG4U39/RfrzudELiq0mcGfwnNK+qQT/1adbZpzrrwKsJhxPXTiwx42lU5b
	FenoI4fu9b3mtMgIfl2/mLPog8Fv2U/Ox1Z37lbyCophe2T5WImlOCPRUIu5qDgRANyrable	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jQV3Wl/whBgves1s8XrOYyWLVhiUs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsng64SKbxeE37awWq3b9YXTg9Ng56y67x51re9g8Ni+p
	9+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGWeO7GQt
	uMxR8fPJcsYGxoPsXYycHBICJhL9R99A2WISF+6tZ+ti5OIQEpjOKDHzwFYoZwKTxP6Nj8Gq
	2AR0JZ68n8sMYosIZEv0317NAlLELLCNUeL79iawImEBR4ktD7uYQGwWAVWJf60NYA28Ah4S
	VxuWAk3lAFqnIDFnks0ERu4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj5Zn0DsZV
	DRaHGAU4GJV4eAVq+UOEWBPLiitzDzFKcDArifBav+ALEeJNSaysSi3Kjy8qzUktPsRoCrR8
	IrOUaHI+MIrzSuINjU3MTY1NLU0sTMwslcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUwSgSU
	sazhXFLwXrVijpyvbsOTxQnM3Mr2Dy8sCtrCfeF4+DUTjbM3hKJ2Tfu3RnXfdm3B0jAdv/bf
	zxR4L7+4e2uucOV5g0Uf7zg8V9/XxtCqYyqz66LX5F2CbzTLKy0P2Sls/mDxLjw0jN+ouUf3
	h4unwZzkKUamz1waU12+CXmyrn9c9G+aEktxRqKhFnNRcSIAluyMWaoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chander Kashyap <k.chander@samsung.com>

The parent name added in parent list as
mout_phyclk_mipi_dphy_4l_m_txbyte_clkhs_p, is different
than the defined parent due to typo.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
---
 drivers/clk/samsung/clk-exynos5260.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos5260.c b/drivers/clk/samsung/clk-exynos5260.c
index 64596ba..4db4e8d 100644
--- a/drivers/clk/samsung/clk-exynos5260.c
+++ b/drivers/clk/samsung/clk-exynos5260.c
@@ -1579,7 +1579,7 @@ struct samsung_fixed_rate_clock fixed_rate_clks[] __initdata = {
 	FRATE(PHYCLK_HDMI_LINK_O_TMDS_CLKHI, "phyclk_hdmi_link_o_tmds_clkhi",
 			NULL, CLK_IS_ROOT, 125000000),
 	FRATE(PHYCLK_MIPI_DPHY_4L_M_TXBYTECLKHS,
-			"phyclk_mipi_dphy_4l_m_txbyteclkhs" , NULL,
+			"phyclk_mipi_dphy_4l_m_txbyte_clkhs" , NULL,
 			CLK_IS_ROOT, 187500000),
 	FRATE(PHYCLK_DPTX_PHY_O_REF_CLK_24M, "phyclk_dptx_phy_o_ref_clk_24m",
 			NULL, CLK_IS_ROOT, 24000000),
-- 
1.7.9.5

