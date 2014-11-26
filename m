Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaKZNaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:30:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40670 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaKZNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:30:07 -0500
X-AuditID: cbfee68f-f791c6d000004834-0a-5475d5dd7ee5
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v3 0/2] Add regulator-haptic driver
Date: Wed, 26 Nov 2014 22:30:00 +0900
Message-id: <1417008602-22841-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWyRsSkWPfu1dIQg55PghbXvzxntTi86AWj
	xY6GI6wWvQuuslnc/PSN1eLyrjlsFjPO72OyWLT1C7sDh8fOWXfZPfq2rGL0+LxJLoA5issm
	JTUnsyy1SN8ugSujcfMbtoJlnBUNBxuZGxgnsHcxcnJICJhIvNkyH8oWk7hwbz1bFyMXh5DA
	UkaJk3veM8IUfW3dyAyRWMQosWLpRqiqNiaJSSt3gLWzCWhLfF+/mBXEFhEIlfh8YRZYB7PA
	LUaJzc92gxUJCxhLTN30Caibg4NFQFVi8T5TkDCvgIfE3fetYGEJAQWJOZNsQFolBL6zSTyf
	2M4EUsMiICDxbfIhFogaWYlNB5ghjpOUOLjiBssERsEFjAyrGEVTC5ILipPSi4z1ihNzi0vz
	0vWS83M3MQKD9fS/Z/07GO8esD7EKMDBqMTDGyFVGiLEmlhWXJl7iNEUaMNEZinR5HxgTOSV
	xBsamxlZmJqYGhuZW5opifMulPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxW3pK5qeX
	hlH5CfuPPBa6tv2jdyvLpZvuk7UXpUZdKT5+59nB94acc6t5O/kexbz+MesUr27fov2x5/c/
	n1vau8KUPeT3/WrVyvTeiZ/Nz636HmLAJyjn8r+Hy2NT5nKePevbqu5sDuRvl1aMCq++K7vK
	PmQnj1YGp6CgedaJjgu2qTEplcpKLMUZiYZazEXFiQAeNiSkUQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xgO7dq6UhBr0TuSyuf3nOanF40QtG
	ix0NR1gtehdcZbO4+ekbq8XlXXPYLGac38dksWjrF3YHDo+ds+6ye/RtWcXo8XmTXABzVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjMbNb9gKlnFWNBxsZG5gnMDexcjJ
	ISFgIvG1dSMzhC0mceHeerYuRi4OIYFFjBIrlm6EctqYJCat3AHWwSagLfF9/WJWEFtEIFTi
	84VZzCBFzAK3GCU2P9sNViQsYCwxddMnoG4ODhYBVYnF+0xBwrwCHhJ337eChSUEFCTmTLKZ
	wMi9gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwLDyT2sG4ssHiEKMAB6MSD2+EVGmI
	EGtiWXFl7iFGCQ5mJRHerxuAQrwpiZVVqUX58UWlOanFhxhNgXZPZJYSTc4HxmleSbyhsYmZ
	kaWRuaGFkbG5kjjvjZu5IUIC6YklqdmpqQWpRTB9TBycUg2M3U4fNS33h4suig9I87HXmHbq
	3L3voS5PJKwSD6zmmFA7uTP2VkDytj0ecabW8qcfpzSfYJnRwXg1aNnEDrXyR2Js85ct/pv3
	p/kCdyCH4fsfu9cb3r4l+vm905GiM6IsEYnGTbsWSHb9Yz/uNDGt3LDvaf3F8J4dD55oSs2Y
	L2rUXDlvppCaEktxRqKhFnNRcSIAINtjhZsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds regulator-haptic driver.
The regulator-haptic has haptic motor and it is controlled by
voltage of regulator via force feedback framework.

Changes in v3:
  - fix typo in Documentation
  - add define in header file

Changes in v2:
  - remove driver owner
  - merge enable/disable function
  - support platform data
 - fix wrong suspends_state check in regulator_haptic_resume()

Jaewon Kim (2):
  Input: add regulator haptic driver
  ARM: dts: Add regulator-haptic device node for exynos3250-rinato

 .../devicetree/bindings/input/regulator-haptic.txt |   21 ++
 arch/arm/boot/dts/exynos3250-rinato.dts            |    7 +
 drivers/input/misc/Kconfig                         |   11 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/regulator-haptic.c              |  247 ++++++++++++++++++++
 include/linux/input/regulator-haptic.h             |   31 +++
 6 files changed, 318 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
 create mode 100644 drivers/input/misc/regulator-haptic.c
 create mode 100644 include/linux/input/regulator-haptic.h

-- 
1.7.9.5

