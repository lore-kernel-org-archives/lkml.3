Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab3GPLxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:53:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17895 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3GPLw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:52:59 -0400
X-AuditID: cbfee691-b7fef6d000002d62-0a-51e53419fc98
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, sbkim73@samsung.com,
        sameo@linux.intel.com, mturquette@linaro.org, lee.jones@linaro.org,
        broonie@kernel.org, yadi.brar01@gmail.com,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 0/3] Add clk driver to register s2mps11 clocks
Date: Sun, 07 Jul 2013 17:14:19 +0530
Message-id: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWyRsSkTlfK5GmgwdRPzBZTHz5hs7j/9Sij
	xabH11gtLu+aw2bxdMJFNovT3awWF1d8YbKY+7uR1WLO9HdMDpweO2fdZffYtKqTzePOtT1s
	HvNOBnpsXlLv0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBmtl+6zFGxnq2h+d5C5gXE7Sxcj
	J4eEgInEz6bfrBC2mMSFe+vZuhi5OIQEljJKfP51gB2mqK1nNyOILSQwnVGifyYnhN3GJLFp
	p1MXIwcHm4CRxKtjdiBhEQEFic29z1hB5jALPGCUePhuM9gCYQE7iW//9rGB2CwCqhJzbzWB
	HcEr4CJx7+g8NohdChKtyw6xgzRLCMxjl9jy5Q4jRIOAxLfJh1hAlkkIyEpsOsAMUS8pcXDF
	DZYJjIILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgSG9el/zybuYLx/wPoQYzLQuInM
	UqLJ+cC4yCuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMH
	p1QDo61WYHd2XsW9e17TSnYG8jPdUuO/vLOp+NT+fzvueYf/2bXisuirm876Tusvmn6Y9NBS
	p5+j89qcA9OZU7V//mLeEX1sV9/r64du5k7+LH3viL7h92zdr39SFd6xc52zu6koa7JhQtO9
	cMmIU20cXIaPtt29bZu48e60jFt7VUxEzGKYXs9R3aPEUpyRaKjFXFScCABvNwTSgQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jQV1Jk6eBBvfemVtMffiEzeL+16OM
	FpseX2O1uLxrDpvF0wkX2SxOd7NaXFzxhcli7u9GVos5098xOXB67Jx1l91j06pONo871/aw
	ecw7GeixeUm9R9+WVYwenzfJBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGHMaL10n6VgO1tF87uDzA2M21m6GDk5JARMJNp6djNC2GISF+6tZwOxhQSmM0r0z+SEsNuY
	JDbtdOpi5OBgEzCSeHXMDiQsIqAgsbn3GWsXIxcHs8ADRomH7zazgiSEBewkvv3bBzaHRUBV
	Yu6tJrBdvAIuEveOzmOD2KUg0brsEPsERu4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3
	MYKj5pn0DsZVDRaHGAU4GJV4eA9yPgkUYk0sK67MPcQowcGsJMJ7i/9poBBvSmJlVWpRfnxR
	aU5q8SHGZKDtE5mlRJPzgRGdVxJvaGxibmpsamliYWJmSZqwkjjvwVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2M6eZul+Plc02+NEUsjLz48eR3vp6gaWmRRa+OLK2Nvfn4JnNLxKNp1ise3Xao
	O/gw/2zywZVqKbf8HTVvvs74OftXWuVbocc2E+8vrVywT3nFXGtOac8VRzWWatw+Iex/Weh6
	9sui57XTE3il/4sUHmn5FLfwYuKB07EdPteMeQyuiSUJr5zpo8RSnJFoqMVcVJwIAF8Qydfe	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support to register three(AP/CP/BT) buffered 32.768 KHz
outputs of mfd-s2mps11 with common clock framework and removes clocks from
regulators list.

Yadwinder Singh Brar (3):
  clk: s2mps11: Add support for s2mps11
  mfd: sec: Add clock cell for s2mps11
  mfd: s2mps11: Remove clocks from regulators list

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   20 ++
 drivers/clk/Kconfig                               |    6 +
 drivers/clk/Makefile                              |    1 +
 drivers/clk/clk-s2mps11.c                         |  273 +++++++++++++++++++++
 drivers/mfd/sec-core.c                            |    4 +-
 include/linux/mfd/samsung/s2mps11.h               |    6 +-
 6 files changed, 304 insertions(+), 6 deletions(-)
 create mode 100644 drivers/clk/clk-s2mps11.c

