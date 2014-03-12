Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaCLEQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:16:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44572 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaCLEQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:16:39 -0400
X-AuditID: cbfee68f-b7f156d00000276c-27-531fdfa5ab9d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 0/4] Introduce new Kconfig for Samsung common clock
Date: Wed, 12 Mar 2014 13:32:57 +0900
Message-id: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zY92l9+WDDQ4eNrDY9Pgaq8XlXXPY
	LGac38dksWjrF3YHFo/NS+o9+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2Nb2w+2gi7uihkL
	NrI3ML7g6GLk5JAQMJFYMeEAO4QtJnHh3nq2LkYuDiGBZYwSe7feBkpwgBX97y6DiE9nlDj6
	7hpUURuTxLPTE8C62QR0JZ68n8sMYosIZEtcmnWLBcRmFtCWmLy3BaxGWMBN4mfnfLAaFgFV
	iVP3V7GALOAVcJfYs8IaYpeCxJxJNiDjJQSus0n82t/CCFEuIPFt8iEWiBpZiU0HmCFulpQ4
	uOIGywRGwQWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxQsKvfwfj3QPWhxiTgcZNZJYS
	Tc4Hhm9eSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amBkePqRM8HXL1vPav+PMl9f6X7nTeqhsVd+vN4kfnxBiO4ZT+ayrHi3Z5u0nkRMPfPznJhA
	5tV1MpusOcObv609dCVq++NgFu9AZXWr5NkvVbz/TPlearaEiXdS/r0sM/eVxutrkjT35nRZ
	i2zkmxz3WZ1bccvFC9dTPjgXrGmav/ybQcCPe31KLMUZiYZazEXFiQDhdACPVQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jQd2l9+WDDbpu6lhsenyN1eLyrjls
	FjPO72OyWLT1C7sDi8fmJfUefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ixre0HW0EXd8WMBRvZGxhfcHQxcnBICJhI/O8u62LkBDLFJC7cW8/WxcjF
	ISQwnVHi6LtrUE4bk8Sz0xPYQarYBHQlnryfywxiiwhkS1yadYsFxGYW0JaYvLcFrEZYwE3i
	Z+d8sBoWAVWJU/dXsYAs4xVwl9izwhpir4LEnEk2Exi5FzAyrGIUTS1ILihOSs810itOzC0u
	zUvXS87P3cQIDu5n0jsYVzVYHGIU4GBU4uFdqCkfLMSaWFZcmXuIUYKDWUmE9yNIiDclsbIq
	tSg/vqg0J7X4EGMy0O6JzFKiyfnAyMsriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6Yklq
	dmpqQWoRzBYmDk6pBsYZaUGCevt91YUX+zkI1ffcilrYKnq76puJu5LXm2mclWZb2HX/zgzZ
	aeqzs63kb8WdB5FM2XHernwzNjhvkmK7kTxZb/oyL/Z/0mZuJm8/2HjcuvlcSN9mfdsjrTNZ
	K+3Fb9w65uxz46LeU+3zJvKtVrnrXrvZpe5+d8OW58Aeua6p6lZOr5VYijMSDbWYi4oTAVbR
	ZceyAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new Kconfig file for Samsung common clock infrastructure
related config options. As current Samsung common clock gets compiled
based on PLAT_SAMSUNG, but moving ahead with ARM64 we can not have any
more such config options, so this patch introduce new COMMON_CLK_SAMSUNG
invisible option. This option also select COMMON_CLK so ARCH Kconfig just
need to select COMMON_CLK_SAMSUNG in case they want to use Samsung common
clock.

This series is based on Kukjin's for-next branch.

V2:
 1) Adding new Kconfig file for Samsung common clock.
 2) Make COMMON_CLK_SAMSUNG option invisible. (as suggested by Tomasz Figa)
 3) Let COMMON_CLK_SAMSUNG select COMMON_CLK. (as suggested by Tomasz Figa)
 4) Move S3C24XX clock config option in new Kconfig file.

Pankaj Dubey (4):
  clk: samsung: add new Kconfig for Samsung common clock options
  drivers: clk: use CONFIG_COMMON_CLK_SAMSUNG for Samsung clock support
  ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and ARCH_S3C64XX
  ARM: S3C24XX: remove S3C24XX specific clock Kconfig options

 arch/arm/Kconfig              |    4 ++--
 arch/arm/mach-s3c24xx/Kconfig |   14 --------------
 drivers/clk/Kconfig           |    2 ++
 drivers/clk/Makefile          |    2 +-
 drivers/clk/samsung/Kconfig   |   11 +++++++++++
 5 files changed, 16 insertions(+), 17 deletions(-)
 create mode 100644 drivers/clk/samsung/Kconfig

-- 
1.7.9.5

