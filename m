Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbaDXMe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:34:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13064 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaDXMez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:34:55 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-46-535904ed4cbf
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 0/9] extcon: Support devm_extcon_dev_allocate/free()
Date: Thu, 24 Apr 2014 21:34:48 +0900
Message-id: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkRPctS2Swwbt/ZhYH79dbTH34hM3i
	35Qb7BbXvzxntejf4mLx+oWhxYWnPWwWZ5vesFtc3jWHzeJ24wo2By6PTas62TxeTvzN5tG3
	ZRWjx9Qpfxk9jt/YzuTxeZNcAFsUl01Kak5mWWqRvl0CV8bxN/NYC9p4KzrnHGdrYHzJ1cXI
	ySEhYCJxdf8rNghbTOLCvfVANheHkMBSRondV9cwdTFygBVd3hQNEZ/OKPHg6E5GCKeJSWLN
	zS52kG42AS2J/S9ugE0SEVCQ2Nz7jBWkiFngGaPEiasnmEESwgJuErOW7GMHmcoioCrRepUF
	JMwr4CpxevZNVogr5CQ+7HnEDtIrIbCIXeL8hN9gRSwCAhLfJh9igbhIVmLTAWaIekmJgytu
	sExgFFzAyLCKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzCwT/971reD8eYB60OMyUDjJjJL
	iSbnAyMjryTe0NjMyMLUxNTYyNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwTk2o6526bevZU5cs4s5Ja4oZCkcF1jrdOnA+xFHAI2L/BSf7CbnTI8y/yoh9/HrTQ9qu
	RvnklxzPX3UBE6YyTy8vMeg5wzvPxlST9+4inc1POi+Jcv2t220vpPx1gWeM7LNnu8KS/ObM
	qluRfWoa78RnQQ+339/q99iy58TOq9OdmXbqqhd/U2Ipzkg01GIuKk4EAHZ4CDKCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jQd23LJHBBq03dC0O3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4vGsOm8XtxhVsDlwem1Z1snm8nPibzaNv
	yypGj6lT/jJ6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZx9/MYy1o463onHOcrYHxJVcXIweHhICJxOVN0V2MnECmmMSFe+vZuhi5OIQEpjNKPDi6
	kxHCaWKSWHOzix2kik1AS2L/ixtsILaIgILE5t5nrCBFzALPGCVOXD3BDJIQFnCTmLVkHzvI
	BhYBVYnWqywgYV4BV4nTs2+yQmyTk/iw5xH7BEbuBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGC4+aZ1A7GlQ0WhxgFOBiVeHgPXAgPFmJNLCuuzD3EKMHBrCTCO/tfRLAQb0piZVVq
	UX58UWlOavEhxmSg5ROZpUST84ExnVcSb2hsYmZkaWRuaGFkbE6asJI474FW60AhgfTEktTs
	1NSC1CKYLUwcnFINjIkBu99LnX/IERe/fckp4a+XIhtfRf9Ovb1w/t/iYyfE/ktpu7vXzRWL
	35JdsOPu7ezuqfHvlbnYz5ZZzytJC0h0uN13chqrSuBxbf+wxsn8lYtPpt1tnB1x9fQcjU7v
	6FC9bVcLf8696GpQ1PX7+023n1OPdRobd9RMkt15c5nzMUcP72JDOyWW4oxEQy3mouJEAKAx
	prvfAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add devm_extcon_dev_allocate/free() for the resource management
of extcon device. And devm_extcon_dev_allocate() handles all of supported cables.

Changes from v2:
- Resolve bisectable issue about patch-1
  extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
- extcon_dev_allocate/free() don't handle all behaviors for supported cables

Changes from v1:
- Rebase it on latest extcon-next branch

Chanwoo Choi (9):
  extcon: Add extcon_dev_allocate/free() to control the memory of extcon device
  extcon: Add devm_extcon_dev_allocate/free to manage the resource of extcon device
  extcon: max8997: Use devm_extcon_dev_allocate for extcon_dev
  extcon: max77693: Use devm_extcon_dev_allocate for extcon_dev
  extcon: max14577: Use devm_extcon_dev_allocate for extcon_dev
  extcon: arizona: Use devm_extcon_dev_allocate for extcon_dev
  extcon: adc-jack: Use devm_extcon_dev_allocate for extcon_dev
  extcon: gpio: Use devm_extcon_dev_allocate for extcon_dev
  extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev

 drivers/extcon/extcon-adc-jack.c |  21 ++++----
 drivers/extcon/extcon-arizona.c  |  31 ++++++-----
 drivers/extcon/extcon-class.c    | 109 ++++++++++++++++++++++++++++++++++-----
 drivers/extcon/extcon-gpio.c     |  23 ++++++---
 drivers/extcon/extcon-max14577.c |   5 +-
 drivers/extcon/extcon-max77693.c |   7 ++-
 drivers/extcon/extcon-max8997.c  |   5 +-
 drivers/extcon/extcon-palmas.c   |  35 +++++++------
 include/linux/extcon.h           |  24 +++++++++
 include/linux/mfd/palmas.h       |   2 +-
 10 files changed, 195 insertions(+), 67 deletions(-)

-- 
1.8.0

