Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3IBAUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:20:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57784 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3IBAUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:20:14 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-cc-5223d9bcb012
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/3] extcon: Code clean to fix up coding style and remove
Date: Mon, 02 Sep 2013 09:20:05 +0900
Message-id: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkWHfPTeUggxmrNC2uf3nOatG8eD2b
	xdmmN+wWl3fNYbO43biCzYHVY//cNewefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfH8+mzG
	goWcFV+OHmFrYDzP1sXIySEhYCKxf88UVghbTOLCvfVAcS4OIYGljBI7Z85hhim6vXshVGI6
	o8TDc68ZIZxGJokV7yexgFSxCWhJ7H9xA2ysiICCxObeZ2BjmQWqJc6dugwWFxbwlDh64jYj
	iM0ioCpxYMFisA28Aq4Ss69uYITYJifxYc8jdpAFEgKP2STe3p3KDtEgIPFt8iGgZRxACVmJ
	TQegrpOUOLjiBssERsEFjAyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MQID8vS/Z/07GO8e
	sD7EmAw0biKzlGhyPjCg80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAGOCWXLLy3uIpvN1xrjUtt7QevXmU2/1pxsWwi7emBDE/WK+W7yHX0tP+
	rbT2/e6dHOL7TjRWBW4qEWLs/XHxommL9bprV3ydIxv/N9Ra2S09/CrUJIR5Y7JO/K493YI2
	+zqtlFamzeGOCDh1fK/SDatnucxsL59E5cuvkO7jW8Lz5WPPuSsaSizFGYmGWsxFxYkAFQOj
	M14CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t9jQd09N5WDDBY8ULK4/uU5q0Xz4vVs
	Fmeb3rBbXN41h83iduMKNgdWj/1z17B79G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWPG8+uzGQsWclZ8OXqErYHxPFsXIyeHhICJxO3dC6FsMYkL99YD
	2VwcQgLTGSUennvNCOE0MkmseD+JBaSKTUBLYv+LG2AdIgIKEpt7n7GC2MwC1RLnTl0GiwsL
	eEocPXGbEcRmEVCVOLBgMTOIzSvgKjH76gZGiG1yEh/2PGKfwMi9gJFhFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZwuD+T3sG4qsHiEKMAB6MSD6/CMuUgIdbEsuLK3EOMEhzMSiK8ccBo
	EeJNSaysSi3Kjy8qzUktPsSYDLR9IrOUaHI+MBbzSuINjU3MjCyNzA0tjIzNSRNWEuc92God
	KCSQnliSmp2aWpBaBLOFiYNTqoFRbJ/67ia7yMW/5yh0HLXJbo47yB/zIKE7m3321+sqrFVW
	//aERPhb2mYEP6tSCLyz5rLmngXbNX+FPzq8bPL1No22ecei26u/HWZkeSyUdFDi6A5XhWPt
	GvH3VVkETwke8D7iM03t9EH5iPtL5p2tnblWXXfe0pPLRfSqrx74qDdd+mun8O1uJZbijERD
	Leai4kQAKMizc7sCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix up indentation coding style and simplify extcon_dev_register()
prototype to improbe usability when registering extcon device.*** BLURB HERE ***

Chanwoo Choi (3):
  extcon: Fix indentation coding style to improve readability
  extcon: Change field type of 'dev' in extcon_dev structure
  extcon: Simplify extcon_dev_register() prototype by removing unnecessary parameter

 Documentation/extcon/porting-android-switch-class |  6 +-
 drivers/extcon/extcon-adc-jack.c                  | 25 +++----
 drivers/extcon/extcon-arizona.c                   |  3 +-
 drivers/extcon/extcon-class.c                     | 85 +++++++++++------------
 drivers/extcon/extcon-gpio.c                      |  3 +-
 drivers/extcon/extcon-max77693.c                  |  3 +-
 drivers/extcon/extcon-max8997.c                   |  3 +-
 drivers/extcon/extcon-palmas.c                    |  3 +-
 include/linux/extcon.h                            | 72 +++++++++----------
 include/linux/extcon/extcon-adc-jack.h            | 42 +++++------
 include/linux/extcon/extcon-gpio.h                | 16 ++---
 11 files changed, 135 insertions(+), 126 deletions(-)

-- 
1.8.0

