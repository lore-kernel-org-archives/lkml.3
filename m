Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaHNAVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:21:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50702 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaHNAVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:21:09 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-64-53ec00ed1ec1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/4] extcon: sm5502: Clean up coding style and fix bug
Date: Thu, 14 Aug 2014 09:20:56 +0900
Message-id: <1407975660-3993-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWyRsSkQPcdw5tgg9UdTBbXvzxntTjb9Ibd
	4vKuOWwWtxtXsDmwePRtWcXo8XmTXABTFJdNSmpOZllqkb5dAlfGqYuvGAumslc8mlHUwPiW
	tYuRk0NCwERi34HrTBC2mMSFe+vZQGwhgaWMEt9OM8LUnPn3nxUiPp1RYsLl2i5GLiC7iUli
	9tRfYA1sAloS+1/cALNFBBQkNvc+A2tgFoiXONvdDTZIWMBDYtPCr2DLWARUJZ5e/MsOYvMK
	uEg8ODKbDWKZnMSHPY/YIewzbBKNpxIh6gUkvk0+xNLFyAEUl5XYdIAZokRS4uCKGywTGAUX
	MDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgMutP/nvXuYLx9wPoQYzLQuInMUqLJ+cCg
	zSuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRuOV
	Drd0N13qX/ikX3Qzw6vyB9JXvndsaA0SXDNtwp4IifL17NtuBnNzLdybN/X15qmfnxWLxhrW
	zqu9KOQ3r+FiF/+KlSqCl1tTShYKTftosv/V3WBPj0vHzlueT1ki8LLoNIf4laKZZTu/pc98
	raowjXXlh1++V2MOqsnee8t199bKL38b9/5VYinOSDTUYi4qTgQAhaTjllACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jQd23DG+CDY6tMLe4/uU5q8XZpjfs
	Fpd3zWGzuN24gs2BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM05dfMVYMJW94tGMogbGt6xdjJwcEgImEmf+/YeyxSQu3FvPBmILCUxnlJhwubaL
	kQvIbmKSmD31F1iCTUBLYv+LG2C2iICCxObeZ2DNzALxEme7uxlBbGEBD4lNC78ygdgsAqoS
	Ty/+ZQexeQVcJB4cmc0GsUxO4sOeR+wTGLkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/d
	xAgO62fSOxhXNVgcYhTgYFTi4fWIeh0sxJpYVlyZe4hRgoNZSYTXbzdQiDclsbIqtSg/vqg0
	J7X4EKMp0PaJzFKiyfnAmMsriTc0NjEzsjQyN7QwMjZXEuc92GodKCSQnliSmp2aWpBaBNPH
	xMEp1cBoJcd1bf+LS/cNvuZLWxRtn6vQ9ZfxbLnhkkOBbm1FVppCz9hWv214KxiZbJ7gLHPo
	mIzqs7W80iG9PhdqdT41+oSHTXhf9X/1kiUHewSFM/J+csWriZbtCWZQ31u6Q3Bnur58ul3h
	tbXM6gtnHVKMaHmV6aA5T8LBli0l12ij6fo/wkuu/VFiKc5INNRiLipOBACpaozZgQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clean up coding style for extcon-sm5502 driver and fix wrong mask
operation to get cable_type value.

Changes from v1:
- Split previous patch as two patch(patch1 and patch2)
- Add I2C dependency to protect build brak when I2C=m

Chanwoo Choi (4):
  extcon: sm5502: Move sm5502.h header file to extcon directory
  extcon: sm5502: Fix bug to check cable type
  extcon: sm5502: Clean up codes by using checkpatch script
  extcon: sm5502: Add I2C dependency to fix build break

 drivers/extcon/Kconfig         |   1 +
 drivers/extcon/extcon-sm5502.c |  19 +--
 drivers/extcon/extcon-sm5502.h | 282 ++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon/sm5502.h  | 287 -----------------------------------------
 4 files changed, 290 insertions(+), 299 deletions(-)
 create mode 100644 drivers/extcon/extcon-sm5502.h
 delete mode 100644 include/linux/extcon/sm5502.h

-- 
1.8.0

