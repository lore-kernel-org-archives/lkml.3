Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3JVMwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:52:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9921 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3JVMwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:52:03 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-a7-526674f16311
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton@enomsg.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: [PATCH 0/4] charger-manager: Support Devicetree and use IIO susbystem
Date: Tue, 22 Oct 2013 21:51:53 +0900
Message-id: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWyRsSkRPdjSVqQwfzF5hYHt2paXP/ynNVi
	/pFzrBYTV05mtjjwZwejxdmmN+wWl3fNYbO43biCzeLwigNMDpweCz5fYfeY0P+J0WPzCi2P
	O9f2sHn0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxrJjW9kK1rFX7D4xm6mB8RFrFyMnh4SA
	icTby1OYIWwxiQv31rN1MXJxCAksZZRYvWIbG0zRr5unwIqEBBYxSpw9VwFR1MgkMfv1BSaQ
	BJuAlsT+FzfAGkQE/CSuv93GBFLELDCdUWLlwj6wdcJAiYYHDUCTODhYBFQlmrflgoR5BVwl
	Plw/CLVMTuLDnkfsIL0SAtPZJc5/vQOWYBEQkPg2+RALSK+EgKzEpgNQV0tKHFxxg2UCo+AC
	RoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIEBffrfs74djDcPWB9iTAYaN5FZSjQ5HxgR
	eSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsaNp
	UrrYNY/Npkc/9NhbPZ27O3BiZveKqYsk9x1bZ+szX0bhZbjfk0VLpQ4El1oFfzxxdWHAy6Vz
	l+dU2D8+pnZpwxafCbPTZ3Xv5+N6kq3Ks9tnuaVqrfPBou747xHT+Xn1We2v3mHsfnBB8Plv
	Rb+Ztadz5gS/2sqQefppuNKpj5O1o180+yuxFGckGmoxFxUnAgCQI9HOfgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jAd2PJWlBBgseGFgc3Kppcf3Lc1aL
	+UfOsVpMXDmZ2eLAnx2MFmeb3rBbXN41h83iduMKNovDKw4wOXB6LPh8hd1jQv8nRo/NK7Q8
	7lzbw+bRt2UVo8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDOW
	HdvKVrCOvWL3idlMDYyPWLsYOTkkBEwkft08xQxhi0lcuLeeDcQWEljEKHH2XEUXIxeQ3cgk
	Mfv1BSaQBJuAlsT+FzfAikQE/CSuv93GBFLELDCdUWLlwj6wqcJAiYYHDUBTOThYBFQlmrfl
	goR5BVwlPlw/yAaxTE7iw55H7BMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6X
	Z1I7GFc2WBxiFOBgVOLhzbBKDRJiTSwrrsw9xCjBwawkwtvsmxYkxJuSWFmVWpQfX1Sak1p8
	iDEZaPlEZinR5HxgLOeVxBsam5gZWRqZG1oYGZuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsT
	B6dUA+Ma9ZNaHFtaPt0Qn8N7ytrrTkg6O8e2VW++cFo+eX/48udMq5ykRsdPoQKXeVcedrtQ
	6cEi7rs/TqvnWdDJ45MuuNdOiXnWp37KXebeib52XlbFjg99v6ITil/PcG263c77a4lPYMSX
	4NKrH67ovVZuODPNM7X5sT5X76VvXnK23/9tj46490GJpTgj0VCLuag4EQCOdiX+2wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support DT(Device Tree) to get platform data for charger desc
structure from dts file and use IIO(Industrial I/O) subsystem to read ADC
value of battery temperature instead of using legacy method.

Chanwoo Choi (4):
  charger-manager: Support DT to get platform data for charger_desc
  charger-manager: Use IIO subsystem to read battery temperature instead of legacy method
  charger-manager: Add device tree binding for charger-manager
  charger-manager: Remove build warning fo unused variable

 .../devicetree/bindings/power/charger-manager.txt  | 106 ++++++
 drivers/power/Kconfig                              |   1 +
 drivers/power/charger-manager.c                    | 379 ++++++++++++++++++++-
 include/linux/power/charger-manager.h              |  25 +-
 4 files changed, 493 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/charger-manager.txt

-- 
1.8.0

