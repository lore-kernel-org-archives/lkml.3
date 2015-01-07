Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbbAGOCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:02:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36467 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbbAGOB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:01:59 -0500
X-AuditID: cbfee68f-f791c6d000004834-35-54ad3c553195
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND 0/2] Add regulator-haptic device tree
Date: Wed, 07 Jan 2015 23:01:51 +0900
Message-id: <1420639313-897-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWyRsSkRDfUZm2IwZPlAhbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyYHVY9OqTjaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgymg7coux
	oIelYsLTtywNjCuYuxg5OSQETCQePN3CDmGLSVy4t54NxBYSWMoosWR+NEzNrcVPoOLTGSVe
	d4t1MXIB2W1MErMPzwMbxCagLfF9/WLWLkYODhEBRYnNCxRAapgFJjFK3Li3ghWkRljARqLp
	/yewQSwCqhJ/b+wGi/MKuElMWwaygANomYLEnEk2IL0SAo/ZJI7uXssIUS8g8W3yIRaIGlmJ
	TQeg7peUOLjiBssERsEFjAyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MQJD8fS/Z/07GO8e
	sD7EKMDBqMTDW9C3JkSINbGsuDL3EKMp0IaJzFKiyfnAgM8riTc0NjOyMDUxNTYytzRTEudd
	KPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj/c7+T2lrE1qaGptNWfdazznzmusar32l
	mFfUjt6ZEwSZXsVWBRdPXXf/nL7rzPVXPT2VhDmYOiakhn4/J+91JzfC9Kv3l/CA3eJF2XeY
	42erFUa8k7+c37b1yvHJhS+MhSe86b70bufZcPHn+z80LPM8/9dFrUOO5wZvrP0btV/nrVz1
	AyuVWIozEg21mIuKEwErWVnYQAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jQd1Qm7UhBtffc1pc//Kc1WJHwxFW
	i/7Hr5ktLu+aw2Yx4/w+JgdWj02rOtk8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwhjGj7cgtxoIelooJT9+yNDCuYO5i5OSQEDCRuLX4CRuELSZx4d56
	MFtIYDqjxOtusS5GLiC7jUli9uF5YA1sAtoS39cvZu1i5OAQEVCU2LxAAaSGWWASo8SNeytY
	QWqEBWwkmv5/AhvEIqAq8ffGbrA4r4CbxLRlIMs4gJYpSMyZZDOBkXsBI8MqRtHUguSC4qT0
	XCO94sTc4tK8dL3k/NxNjOBQfya9g3FVg8UhRgEORiUe3oK+NSFCrIllxZW5hxglOJiVRHjf
	/AIK8aYkVlalFuXHF5XmpBYfYjQFWj6RWUo0OR8Yh3kl8YbGJmZGlkbmhhZGxuZK4rxK9m0h
	QgLpiSWp2ampBalFMH1MHJxSDYwaG7xSHsxv3W9jzZDBvLc60MU4TXBikUTr30XFe9Z8EWLo
	Zvp187eheuO5aDY/pXM8KxMvCBnM/Lx+ktTvS2ujv0T/ytuw79Kh5S5WRceOTK3VmXTw/fZa
	YHLwf/Xqur059+t86c4NnVESrzVqWu/N/F4+r1RNx+iqDGdI7ZxFB522aoWpiyuxFGckGmox
	FxUnAgAw9XTTiwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds regulator-haptic device tree in rinato and monk boards.

The regulator-haptic has haptic motor and it is controlled by
voltage of regulator via force feedback framework.

Jaewon Kim (2):
  ARM: dts: exynos3250-rinato: Add regulator-haptic node for haptics
  ARM: dts: exynos3250-monk: Add regulator-haptic node for haptics

 arch/arm/boot/dts/exynos3250-monk.dts   |    7 +++++++
 arch/arm/boot/dts/exynos3250-rinato.dts |    7 +++++++
 2 files changed, 14 insertions(+)

-- 
1.7.9.5

