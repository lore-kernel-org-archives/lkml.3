Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaHKJXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:23:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23944 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaHKJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:23:15 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-64-53e88b7baf40
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/2] extcon: rt8973a: Add Richtek RT8973A MUIC driver
Date: Mon, 11 Aug 2014 18:23:01 +0900
Message-id: <1407748983-15539-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWyRsSkQLe6+0WwwdS7qhbXvzxntTjb9Ibd
	4vKuOWwWtxtXsFnMmPySzYHVo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDKuft7EWvCSo6L7
	2DSWBsanbF2MnBwSAiYSn/9cYoewxSQu3FsPFhcSWMooMWFZGkzNjMvnWbsYuYDi0xklDvR/
	YIdwmpgkbv18BNbNJqAlsf/FDbBuEQEFic29z1hBbGaBcomVR/Yxg9jCAq4SzxpOgtWzCKhK
	TD3czwRi8wLFZ9w7wQSxTU7iw55HYAskBK6zSRy4vo8VokFA4tvkQyxdjBxACVmJTQeYIeol
	JQ6uuMEygVFwASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAIDz971nvDsbbB6wPMSYD
	jZvILCWanA8M4rySeENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYf
	YmTi4JRqYHTYvun2nPOLmj5t+h8wg/3PkXyun89qH/lNYDQsuvas1Sv5eLxS4pyc6wrb7Qt+
	MmpuTpzzTmeSjwxjT8dffrGihvh5XavnPbo2f0u8cMYj2dlKLxOC/cLjZdamBEzaXh/GcEMx
	/du/+2evZkpX1936vUJu3kt/3pftdSePl33yvVV44nWd63MlluKMREMt5qLiRAABjfnhWAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQd3q7hfBBj83yltc//Kc1eJs0xt2
	i8u75rBZ3G5cwWYxY/JLNgdWj74tqxg9Pm+SC2CKamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMuPp5E2vBS46K7mPTWBoYn7J1MXJySAiYSMy4fJ4VwhaTuHBvPVCci0NI
	YDqjxIH+D+wQThOTxK2fj9hBqtgEtCT2v7gB1i0ioCCxufcZWDezQLnEyiP7mEFsYQFXiWcN
	J8HqWQRUJaYe7mcCsXmB4jPunWCC2CYn8WHPI/YJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfm
	pesl5+duYgQH+TPpHYyrGiwOMQpwMCrx8B788jxYiDWxrLgy9xCjBAezkgjvT4sXwUK8KYmV
	ValF+fFFpTmpxYcYTYG2T2SWEk3OB0ZgXkm8obGJmZGlkbmhhZGxuZI478FW60AhgfTEktTs
	1NSC1CKYPiYOTqkGRm1uE73YU7NP6SV8v7CEb5LW7OdnGKYxC2SEdSSk9s/f9sbkUfD0zPY5
	LpIzc31NpIwSF6dxXAu8vMtyyRTezzznd7P43OwzWZAYff/cppr5rzTnbqs0kKhcUOb24fXh
	lsaroR56h29U2vxa5xPefmvbcrsaqemhWn+mLHW13MKo1Tol/PqFC0osxRmJhlrMRcWJAFrw
	EQyIAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add new Richtek RT8973A MUIC (Micro-USB IC) driver.
The RT8973A is a USB port accessory detector and switch that is optimized to
protect low voltage system from abnormal high input voltage (up to 28V) and
supports high speed USB operation. Also, RT8973A support 'auto-configuration'
mode. If auto-configuration mode is enabled, RT8973A would control internal
h/w patch for USB D-/D+ switching.

Chanwoo Choi (2):
  extcon: rt8973a: Add Richtek RT8973A extcon driver
  dt-bindings: extcon: Add support for Richtek RT8973A MUIC device

 .../devicetree/bindings/extcon/extcon-rt8973a.txt  |  25 +
 drivers/extcon/Kconfig                             |  11 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-rt8973a.c                    | 742 +++++++++++++++++++++
 drivers/extcon/extcon-rt8973a.h                    | 203 ++++++
 5 files changed, 982 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-rt8973a.txt
 create mode 100644 drivers/extcon/extcon-rt8973a.c
 create mode 100644 drivers/extcon/extcon-rt8973a.h

-- 
1.8.0

