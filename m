Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbbABIE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 03:04:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38230 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbABIEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 03:04:20 -0500
X-AuditID: cbfee68e-f79b46d000002b74-2b-54a650eddb57
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH v2 RESEND 0/2] mfd: arizona: Add support for
 OUTn_MONO register control
Date: Fri, 02 Jan 2015 17:03:47 +0900
Message-id: <1420185829-24886-1-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkUPdtwLIQg2mvNC2mPnzCZvFvyg12
	i/lHzrFa9L9ZyGqx6+99Rotzr1YyWtz/epTR4vKuOWwWS69fZLJY/vY/m8WE6WtZLFr3HmG3
	ON3N6sDrsWbeGkaPy329TB4rl39h89i0qpPN4861PWwe804Geryc+JvNo2/LKkaPz5vkAjij
	uGxSUnMyy1KL9O0SuDKezn7MXjCftWLKh2esDYwTWLoYOTkkBEwk3n5rZYewxSQu3FvP1sXI
	xSEksJRRov/SYlaYojc979khEosYJXb+mswI4cxhkrj1/CozSBWbgIbE98+bwWwRAR2Jzx+P
	MYMUMQvsYZKYtGA12A5hgTSJzr2LmEBsFgFViT8broDZvAJuEkvXToK6SVtiX8NMsDskBI6x
	S/xeM58VokFA4tvkQ0BFHEAJWYlNB5gh6iUlDq64wTKBUXABI8MqRtHUguSC4qT0IiO94sTc
	4tK8dL3k/NxNjMDYOP3vWd8OxpsHrA8xCnAwKvHwKlxbGiLEmlhWXJl7iNEUaMNEZinR5Hxg
	BOaVxBsamxlZmJqYGhuZW5opifMmSP0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDYp3F1
	9o7ltgteGSicuewbrKt8wskv4uHEZec2e0tdCT9hqRDYcs76NNvbNzEL+yP7Gll2hu6wteLv
	mxlzwk7bYe/jiN8/jt+KajYwi/+yVTPs8+buvoa23uYpTwsKf3Pd4tNs+BB/8GZ1Ve6aj0Z7
	t3p9LPvFZHGX23Ld9dX7ovomTfo3dTuvEktxRqKhFnNRcSIASmGZ/IgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t9jAd23ActCDC5PULKY+vAJm8W/KTfY
	LeYfOcdq0f9mIavFrr/3GS3OvVrJaHH/61FGi8u75rBZLL1+kcli+dv/bBYTpq9lsWjde4Td
	4nQ3qwOvx5p5axg9Lvf1MnmsXP6FzWPTqk42jzvX9rB5zDsZ6PFy4m82j74tqxg9Pm+SC+CM
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8XT2Y/aC+awVUz48Y21gnMDS
	xcjJISFgIvGm5z07hC0mceHeerYuRi4OIYFFjBI7f01mhHDmMEncen6VGaSKTUBD4vvnzWC2
	iICOxOePx5hBipgF9jBJTFqwGmyUsECaROfeRUwgNouAqsSfDVfAbF4BN4mlaydBrdaW2Ncw
	k20CI/cCRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGR90x6B+OqBotDjAIcjEo8vArX
	loYIsSaWFVfmHmKU4GBWEuHtk1sSIsSbklhZlVqUH19UmpNafIjRFGj7RGYp0eR8YFLIK4k3
	NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpgTNnp2Nn5+Z/hi5z49G2b
	y3RuhknW/NBlLHjTM503iOftlwferSceO+krLPJ2eSOkrNeZFOR90EP46dpTsw3+6h8/o33z
	QuYByZxTM1TSZnXIBF+t4ZML++capf/899uI6urA/7ks5h5vrb4Wv9Zl8vy0cb/qp+yvIgIy
	0++c+x38I/LgRf5wJZbijERDLeai4kQAKNE3DtICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for OUTn_MONO register control using platform data.
Each output signal can be configurated as a mono differential output.
The mono differential configuration is selected using the OUTn_MONO registers.

Changes in v2:
 - fix coding style issue
 - use ">=" instead of "==" in condition check

Inha Song (2):
  mfd: arizona: Add support for OUTn_MONO register control
  mfd: arizona: Update DT binding to support OUTn_MONO init_data

 Documentation/devicetree/bindings/mfd/arizona.txt |  7 +++++++
 drivers/mfd/arizona-core.c                        | 10 ++++++++++
 2 files changed, 17 insertions(+)

-- 
2.0.0.390.gcb682f8

