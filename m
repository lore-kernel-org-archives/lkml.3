Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3GHM7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:59:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64400 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3GHM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:59:48 -0400
X-AuditID: cbfee68e-b7f276d000002279-ad-51dab7c2558f
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, broonie@kernel.org, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [v2 PATCH 0/6] Add DT support for s2mps11
Date: Sat, 29 Jun 2013 18:21:14 +0530
Message-id: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWyRsSkRvfQ9luBBpefKlhMffiEzeLAnx2M
	Ft+udDBZXN41h83i8IoDTBYn//QyWpzuZrW4uOILk8Xc342sFnOmv2Ny4PJY8PkKu8fOWXfZ
	PTat6mTzuHNtD5vHvJOBHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJWxdO5i9oJmnopV7awN
	jO2cXYycHBICJhLNfc+YIWwxiQv31rOB2EICSxklVu6Dq1n6+zRrFyMXUHwRo8SWCW8YIZw2
	JomFiyczdTFycLAJGEm8OmYH0iAioCCxufcZWAOzwFtGiaVLb7CAJISBarZ2rGIFqWcRUJVo
	emUCEuYVcJU496mNBWKZgkTrskPsIL0SAqvYJXZc72YCSbAICEh8m3yIBaRXQkBWYtMBqKMl
	JQ6uuMEygVFwASPDKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYzAAD/971nfDsabB6wPMSYD
	jZvILCWanA+MkLySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MEp1TTIxFd8ftNni29KYnL6MebZ8807NnZVrE2e5qNg8YseGRr5DSxdaFWvt68rn
	eiWQ/XLq2x33tpg6LzWQjd/NL+Fc/u98pr2j06b8xRfnStemXfitNu/Hji0Zy1pu/NMue6id
	d93rknhCWHFz6LKTvLI3vm7RusBic2HbIzGTUyKzla5lqimxFGckGmoxFxUnAgAHrJsIhgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd1D228FGjy5JG4x9eETNosDf3Yw
	Wny70sFkcXnXHDaLwysOMFmc/NPLaHG6m9Xi4oovTBZzfzeyWsyZ/o7Jgctjwecr7B47Z91l
	99i0qpPN4861PWwe804GevRtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjKVzF7MXNPNUrGpnbWBs5+xi5OSQEDCRWPr7NCuELSZx4d56ti5GLg4hgUWM
	ElsmvGGEcNqYJBYunszUxcjBwSZgJPHqmB1Ig4iAgsTm3mesIDXMAm8ZJZYuvcECkhAGqtna
	sYoVpJ5FQFWi6ZUJSJhXwFXi3Kc2FohlChKtyw6xT2DkXsDIsIpRNLUguaA4KT3XSK84Mbe4
	NC9dLzk/dxMjOIKeSe9gXNVgcYhRgINRiYdX4vTNQCHWxLLiytxDjBIczEoivOKstwKFeFMS
	K6tSi/Lji0pzUosPMSYDLZ/ILCWanA+M7rySeENjE3NTY1NLEwsTM0vShJXEeQ+2WgcKCaQn
	lqRmp6YWpBbBbGHi4JRqYJwj11T3teeG5AWdmecMz0eyRy06YHTbd6Pr+8VpJpfD55sdK3+0
	/pXSzB9cv6QeFGRWzFrgtHUvQ1dYud6mJyXtDdfcc4qlUj/GGW9dIZS5WLv4V++9oGvCffsV
	wlZWqxp+5P0tdOH8+7PshfoG927+YFllt98+OTDld9fD/kM726d5t0x8+VSJpTgj0VCLuag4
	EQBJu3bK5AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly this series adds dt support for s2mps11 in mfd and regulator driver.

changes since v1:
- As suggested by Mark, used regulator-ramp-delay = <0> as ramp_disable and
  Moved the ramp_disable into regulator constraints as it is quite generic.
- Implemented set_ramp_delay callback, to make driver simple and in more
  compliance with framework.
- Modified Documentation accordingly.
- Fixed some NITs pointed by Sachin.

It also includes a patch to remove some redundant checks in _regulator_do_set_voltage().

Yadwinder Singh Brar (6):
  regulator: core: Add support for disabling ramp delay
  regulator: s2mps11: Implement set_ramp_rate callback for bucks
  regulator: s2mps11: Add DT support
  regulator: s2mps11: Convert driver completely to use set_ramp_delay
    callback
  regulator: core: Remove redundant checks
  mfd: s2mps11: Add device tree support

 Documentation/devicetree/bindings/mfd/s2mps11.txt  |   89 +++++++++
 .../devicetree/bindings/regulator/regulator.txt    |    2 +
 drivers/mfd/sec-core.c                             |    3 +
 drivers/regulator/core.c                           |    7 +-
 drivers/regulator/of_regulator.c                   |   12 +-
 drivers/regulator/s2mps11.c                        |  203 +++++++++++++++-----
 include/linux/mfd/samsung/s2mps11.h                |   11 +
 include/linux/regulator/machine.h                  |    1 +
 8 files changed, 270 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/s2mps11.txt

