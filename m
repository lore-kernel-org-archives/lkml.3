Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbaDBHqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:46:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34232 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbaDBHqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:46:21 -0400
X-AuditID: cbfee690-b7f266d00000287c-66-533bc0280ab8
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 0/3] Add PMU node for Exynos4210, Exynos4412, Exynos4212
Date: Wed, 02 Apr 2014 17:02:55 +0900
Message-id: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+Zsa7GAetgg+WTjSyWTbrLZjH/yDlW
	i/43C1ktzr1ayWjRu+Aqm8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hksWjrF3aLCdPXsli0
	7j3C7sDrsWbeGkaPluYeNo/Lfb1MHiuXf2Hz2LSqk81j85J6j74tqxg9Pm+SC+CI4rJJSc3J
	LEst0rdL4MrYceE9S8F09orvh88yNTDuZe1i5OSQEDCR2NV1gBnCFpO4cG89WxcjF4eQwDJG
	iQtbDjF2MXKAFS1byQkRnw4UP/KbCcJpY5I4PHE3E0g3m4CuxJP3c5lBEiIC7YwSTy6vYwRx
	mAVeMkp8/TURrEpYwENi6pr3YGNZBFQlTpzMAQnzCrhLPN84mxVim4LEnEk2IK0SAsfYJX60
	3wc7lUVAQOLb5EMsEDWyEptgrpaUOLjiBssERsEFjAyrGEVTC5ILipPSi0z0ihNzi0vz0vWS
	83M3MUKiYcIOxnsHrA8xJgONm8gsJZqcD4ymvJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgzGX4FFnscf+C+vnY7Pmc/pd9V///qSZ9KmCyV7VQ
	YvHr21Puuvx4FFXcIZeqkD0jf1mQbP+vH8t050nGa8d0FO7YMUUxzq/hnmi47IGH2cXBGaov
	D607+kN1U6H5vIxTemqvX6YkrzZ/8zilcbJ2qHDzW4M9MaX3ZrL12y+4pxHywNLW78sUJZbi
	jERDLeai4kQAMu/qn5wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQV2NA9bBBtvf61gsm3SXzWL+kXOs
	Fv1vFrJanHu1ktGid8FVNotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYtHWL+wWE6avZbFo
	3XuE3YHXY828NYweLc09bB6X+3qZPFYu/8LmsWlVJ5vH5iX1Hn1bVjF6fN4kF8AR1cBok5Ga
	mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
	ILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY8eF9ywF09krvh8+y9TAuJe1i5GDQ0LA
	RGLZSs4uRk4gU0ziwr31bF2MXBxCAtMZJS4c+c0E4bQxSRyeuJsJpIpNQFfiyfu5zCAJEYF2
	Roknl9cxgjjMAi8ZJb7+mghWJSzgITF1zXtGkBUsAqoSJ07mgIR5Bdwlnm+cDbVZQWLOJJsJ
	jNwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH2jOpHYwrGywOMQpwMCrx8B44bxUs
	xJpYVlyZe4hRgoNZSYSXc5J1sBBvSmJlVWpRfnxRaU5q8SHGZKDdE5mlRJPzgWkgryTe0NjE
	zMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoY1e06nnpXpdoFrXknZOUg
	xK87N6DS/WJC/EOjMtueWE31kknrqk9WLJvh8L/YevvkRR/LFLKf5qVGXRS/XHDftC/0/+Lk
	WSGB3nrRW++rdp3g8XJ/ktGilmDi+dnzjGL3AdXgd7Um6z+Ht/zNmrlO+gizqsYxkYzthc4H
	1JsYMouDucSizymxFGckGmoxFxUnAgCf3/zy+QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates Exynos4210, Exynos4412 and Exynos4212 dtsi files
for adding PMU (Power Management Unit) reg node. Also updated binding
document for the same. 
These patches required for using PMU base address via DT for these SoC.
Patches for using PMU base address via DT are posted here-

http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg27875.html

Pankaj Dubey (3):
  ARM: dts: Add PMU reg node to exynos4210
  ARM: dts: Add PMU reg node to exynos4212 and exynos4412
  Documentation: update samsung pmu binding information for
    Exynos4210/4212/4412

 Documentation/devicetree/bindings/arm/samsung/pmu.txt |    3 +++
 arch/arm/boot/dts/exynos4210.dtsi                     |    5 +++++
 arch/arm/boot/dts/exynos4212.dtsi                     |    5 +++++
 arch/arm/boot/dts/exynos4412.dtsi                     |    5 +++++
 4 files changed, 18 insertions(+)

-- 
1.7.10.4

