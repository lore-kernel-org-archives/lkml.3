Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaKXK56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:57:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22552 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaKXK5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:57:54 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-c7-54730f30454d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com
Cc: jh80.chung@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        yj44.cho@samsung.com, geunsik.lim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 0/3] ARM: dts: add the support of Exynos3250-based Monk board
Date: Mon, 24 Nov 2014 19:57:47 +0900
Message-id: <1416826670-29438-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWyRsSkUNeAvzjE4PgENYvrX56zWsw/co7V
	4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWmx5fY7W4vGsOm8WM8/uYLJZev8hkMWH6WhaL
	1r1H2C1mTH7JZrF352RGB36PNfPWMHpsWtXJ5rF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp
	2yVwZWx4KltwiaOi8/gNtgbGl2xdjJwcEgImEltOnWKGsMUkLtxbDxTn4hASWMoocWnRARaY
	ooamn1CJ6YwSLRPaoJwmJonXB/pZQarYBLQk9r+4ATZWRCBSYuW6H6wgRcwCW5gkHk0EcTg4
	hAX8JV5NcAWpYRFQlVi6YT4LSJhXwFVi2/88iGUKEsuWzwRrlRDYxi5x+fMsFoh6AYlvkw+B
	1UsIyEpsOgB1taTEwRU3WCYwCi5gZFjFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERgDp/89
	m7CD8d4B60OMAhyMSjy8HzYWhQixJpYVV+YeYjQF2jCRWUo0OR8YaXkl8YbGZkYWpiamxkbm
	lmZK4ryvpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCsN1N7sP/y3sctk1+ficuYt7Xu
	R7Cm2bOEKXMO1RovdTZb8PTezJo4o5ridyfrNPle8smWuHyLUt8q9vRlw43jZ9aE8f7eWLSu
	+Vb3TceXq27eYp4d5hPftPZPpeJTrT/fOY6lmdU6/fwS/+PWRfnuvkt+u/O37k3Y3XJOw+OF
	1wWX6v232NdxKLEUZyQaajEXFScCACEy0DF8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jQV0D/uIQg0vrZS2uf3nOajH/yDlW
	iz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jslh6/SKTxYTpa1ks
	WvceYbeYMfklm8XenZMZHfg91sxbw+ixaVUnm8fmJfUefVtWMXp83iQXwBrVwGiTkZqYklqk
	kJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SukkJZYk4pUCggsbhY
	Sd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjw1PZgkscFZ3Hb7A1ML5k62Lk5JAQMJFoaPoJ
	ZYtJXLi3Hsjm4hASmM4o0TKhDcppYpJ4faCfFaSKTUBLYv+LG2AdIgKREivX/WAFKWIW2MIk
	8WgiiMPBISzgL/FqgitIDYuAqsTSDfNZQMK8Aq4S2/7nQSxTkFi2fCbrBEbuBYwMqxhFUwuS
	C4qT0nON9IoTc4tL89L1kvNzNzGCI+yZ9A7GVQ0WhxgFOBiVeHhnrC8KEWJNLCuuzD3EKMHB
	rCTCu4+xOESINyWxsiq1KD++qDQntfgQoynQ8onMUqLJ+cDozyuJNzQ2MTOyNDI3tDAyNlcS
	571xMzdESCA9sSQ1OzW1ILUIpo+Jg1OqgVHu3Z9dp1stM9X4zr/6xt6+VfZ6eUpXwuSUY0G7
	wj+y1HdtYdp9UmQb0+zGy59Oz5gu2RIe8HEOr0j4zD+zv56ZxMi7csesqlYFt9wVM/yjMrkF
	+IydGvfumcc6Za9bBpvhm8qFK55WO0xUOMHN55Rfe79hXdfRSiGP8sPOKjzPFqssCynXuaXE
	UpyRaKjFXFScCABjUxg8xgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the support of Exynos3250-based Monk board and Exynos-based
boards compatible string and description to remove build warning. Also, this
patchset includes a patch which remove unused dt node for command line in
Exynos3250-based Rinato dts file.

Changes from v2:
- Include new patches by Chanwoo Choi with following patch[1]
  [1] http://www.spinics.net/lists/arm-kernel/msg368443.html

Changes from v1:
- Fix minor issue

Chanwoo Choi (2):
  ARM: exynos: Add Exynos-based boards compatible string and description
  ARM: dts: Remove unused command line from Exynos3250-based Rinato board

Youngjun Cho (1):
  ARM: dts: add board dts file for Exynos3250-based Monk board

 .../devicetree/bindings/arm/samsung-boards.txt     |  19 +-
 arch/arm/boot/dts/Makefile                         |   3 +-
 arch/arm/boot/dts/exynos3250-monk.dts              | 579 +++++++++++++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts            |   4 -
 4 files changed, 595 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/boot/dts/exynos3250-monk.dts

-- 
1.8.5.5

