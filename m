Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3AXNjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:39:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26268 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3AXNjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:39:11 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-a7-5101397d8089
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, cpgs@samsung.com
Subject: [PATCH v2 0/2] usb: exynos: Fix compatible strings used for device
Date: Thu, 24 Jan 2013 19:15:28 +0530
Message-id: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkVrfWkjHQYEELj8XlXXPYLGac38dk
	sWhZK7MDs8fnTXIBjFFcNimpOZllqUX6dglcGQ1XzAo+s1Zsn/6IrYHxHksXIyeHhICJxNWd
	M1ghbDGJC/fWs4HYQgJLGSVO/ZOCqfn7bhFQnAsoPp1Rov/DSqiiyUwSq7a4gdhsAroSTW93
	MYLYIgKyEoev/GYGaWAW+Mkkca5rE1ADB4ewgLfE61UpIDUsAqoSfft2goV5BTwkPlwLg9il
	IPHm9jOwVgmBE2wS6zuXsUPUC0h8m3yIBaReAmj+pgPMEPWSEgdX3GCZwCi4gJFhFaNoakFy
	QXFSeq6RXnFibnFpXrpecn7uJkZggJ3+90x6B+OqBotDjAIcjEo8vBXqDIFCrIllxZW5hxgl
	OJiVRHjXszAGCvGmJFZWpRblxxeV5qQWH2JMBlo+kVlKNDkfGPx5JfGGxibmpsamlkZGZqam
	pAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoHR8I3PuTv+WgsnRzx5qzUt9nyf56bw0MpF
	B9Y9Fk82+Srcd1tjz5q9JqWLjnY96/yyxKHpzMWtxXq/k87PeNa36cLEe2qn2H/fl2Sd+25z
	3qIv0vYB1XqhEyXuyy8xmfr50Eb/TbGuDytPnFrknK69o7fG4+CkwnsSm80vmV7L1Fjn+faK
	VQ67phJLcUaioRZzUXEiAIUUbul0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jQd0aS8ZAg/sTrCwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcxouGJW
	8Jm1Yvv0R2wNjPdYuhg5OSQETCT+vlvEBmGLSVy4tx7I5uIQEpjOKNH/YSVYQkhgMpPEqi1u
	IDabgK5E09tdjCC2iICsxOErv5lBGpgFfjJJnOvaBNTAwSEs4C3xelUKSA2LgKpE376dYGFe
	AQ+JD9fCIHYpSLy5/Yx5AiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBAfxMegfj
	qgaLQ4wCHIxKPLwV6gyBQqyJZcWVuYcYJTiYlUR417MwBgrxpiRWVqUW5ccXleakFh9iTAZa
	PpFZSjQ5HxhdeSXxhsYm5qbGppYmFiZmlqQJK4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmDU6qB
	UeOk+i6+C2KneiTqF1goK6TwlhZfWiI6qfFmXdbjubbzYv4JJiiWXns57a1ixV8Gh4kvb7M1
	dBdFnTldVrAq4d77LU9DPTy+mU+8mGO5t01NbynHqYNXnJpvCpslr9sj4OjQ9uvUIS6tzwUf
	UlVrlk09dn31cc647WveuJ79t1nu1+GjdzQOdCmxFGckGmoxFxUnAgBPhDDVpAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using chip specific compatible string as it should be.
So fixing this for ehci-s5p, ohci-exynos and dwc3-exynos
which till now used a generic 'exynos' in their compatible strings.

Changes from v1:
	- Changing compatible string from "samsung,exynos5250-dwc3" to
	  "samsung,exynos5250-dwusb3" as per discussion happened in thread:
	  [PATCH 0/2] usb: exynos: Fix compatible strings used for device.

Vivek Gautam (2):
  usb: ehci-s5p/ohci-exynos: Fix compatible strings for the device
  usb: dwc3-exynos: Fix compatible strings for the device

 drivers/usb/dwc3/dwc3-exynos.c |    2 +-
 drivers/usb/host/ehci-s5p.c    |    2 +-
 drivers/usb/host/ohci-exynos.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.6.5

