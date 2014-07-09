Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaGIEsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:48:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64243 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaGIEsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:48:22 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-0e-53bcc99462a8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        geunsik.lim@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCHv2 0/2] regulator: of: Add support for pasing regulator
 suspend state
Date: Wed, 09 Jul 2014 13:48:09 +0900
Message-id: <1404881291-7949-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWyRsSkQHfKyT3BBu8bTC2mPnzCZnH9y3NW
	i/lHzrFa/JnQymZx4M8ORovXLwwtzja9Ybf4dqWDyeLyrjlsFq17j7A7cHnsnHWX3WPTqk42
	jzvX9rB59G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8b+jU/YCyZxVzTOfsfUwNjI2cXIwSEh
	YCJxfZV8FyMnkCkmceHeerYuRi4OIYGljBIHvrxhg0iYSCzasp8VIjGdUeLMwROMEE4Tk8S0
	HSeYQarYBLQk9r+4AdYhAjTq9pxOZpAiZoHvjBJvnh5jB0kIC8RKXJ+6lxXEZhFQlXhy6xUL
	iM0r4CLRM3kTI8Q6OYkPex6xgzRLCExnl3jx8RYjRIOAxLfJh1gg7paV2HSAGaJeUuLgihss
	ExgFFzAyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIDOrT/5717mC8fcD6EGMy0LiJzFKi
	yfnAqMgriTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BsaFu7ISgrfe3t7MNYtNo3B9cHmY2Gul5QGR1ooHenhfaLxiUZlpWlY+xfvJvfcv1keF6194
	vbZF9eYaRaWfX9s0EwKPeL9zzeV7vl5qXd5C2w/dL684MbT2KfScLT+xmeNgl67CzY7LJ2RL
	J/UsSIzVvvGphkOmIvIw88Er3SeeuTZJPF1mvkOJpTgj0VCLuag4EQCyd750gAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t9jQd0pJ/cEG0yfrGsx9eETNovrX56z
	Wsw/co7V4s+EVjaLA392MFq8fmFocbbpDbvFtysdTBaXd81hs2jde4Tdgctj56y77B6bVnWy
	edy5tofNo2/LKkaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	7N/4hL1gEndF4+x3TA2MjZxdjJwcEgImEou27GeFsMUkLtxbz9bFyMUhJDCdUeLMwROMEE4T
	k8S0HSeYQarYBLQk9r+4wQZiiwB13J7TyQxSxCzwnVHizdNj7CAJYYFYietT94KNZRFQlXhy
	6xULiM0r4CLRM3kTI8Q6OYkPex6xT2DkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMj
	OGqeSe9gXNVgcYhRgINRiYdXgWdPsBBrYllxZe4hRgkOZiUR3m9uQCHelMTKqtSi/Pii0pzU
	4kOMpkDbJzJLiSbnAyM6ryTe0NjEzMjSyNzQwsjYXEmc92CrdaCQQHpiSWp2ampBahFMHxMH
	p1QDo/niecx/57yWKp3U0/LR3rH7TPkMnVn2p/L/PNjBEW7OzrK48teq2guuruWpJxplrXNq
	+aRn7VvxhVnv/osb6WnvFs2sdZGMlj60ecE+fo9vhZ3RRbtqZ+nVbr9+3ctflinqxJo3R46c
	13UWOLbx64P6vR+emQrHJdx7cjb9s4vCjfWt7XN3xSuxFGckGmoxFxUnAgAStObgsAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulators would set different state/mode according to the kind of suspend
state. So regulation_constraints structure has already regulator suspend state filed.
This patch parse regulator suspend state from devicetree file.

For example:

	ldoX_reg: LDOx {
		regulator-name = "VAP_XXX_1.2V";
		regulator-min-microvolt = <1200000>;
		regulator-max-microvolt = <1200000>;
		regulator-always-on;

		regulator-initial-state = <3>;	/* PM_SUSPEND_MEM */
		regulator-state-standby {
			regulator-volt = <1200000>;
		};

		regulator-state-mem {
			regulator-volt = <1200000>;
			regulator-off-in-suspend;
		};

		regulator-state-disk {
			regulator-volt = <1200000>;
			regulator-on-in-suspend;
		};
	};

Changes from v1:
- Check whether regulator-initial-state and regulator-mode is correct or not
- Add more detailed description about regulator-initial-state, regulator-mode
  and regulator-state-[standby/mem/disk] for devicetree bindings
- Modify example of regulator suspend state in bindings documentation

Chanwoo Choi (2):
  regulator: of: Add support for parsing regulator_state for suspend state
  dt-bindings: regulator: Add regulator suspend state for PM state

 .../devicetree/bindings/regulator/regulator.txt    | 32 +++++++++
 drivers/regulator/of_regulator.c                   | 76 +++++++++++++++++++++-
 2 files changed, 106 insertions(+), 2 deletions(-)

-- 
1.8.0

