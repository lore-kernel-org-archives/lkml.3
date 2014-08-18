Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaHRG1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:27:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26492 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaHRG1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:27:13 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-0c-53f19cbeec8c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 0/2] regulator: of: Add support for pasing regulator suspend
 state
Date: Mon, 18 Aug 2014 15:27:01 +0900
Message-id: <1408343223-4043-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkWHffnI/BBvvuy1lMffiEzeL6l+es
	FvOPnGO1OPBnB6PF6xeGFmeb3rBbfLvSwWRxedccNovWvUfYHTg9ds66y+6xaVUnm8eda3vY
	PPq2rGL0+LxJLoA1issmJTUnsyy1SN8ugStj17JzjAWzeCpubm5mbmD8xtnFyMkhIWAi0Tj/
	GiOELSZx4d56ti5GLg4hgaWMEjsmXWODKer+/oYRIjGdUaLt1BpWkISQQBOTROsjMJtNQEti
	/4sbYA0iQJNuz+lkBmlgFrjHKPFl9UMWkISwQJjEgzXPgRIcHCwCqhLbbjOBhHkFXCS2TVzD
	ArFMTuLDnkfsIL0SAv3sEqd/NIEVsQgISHybfIgFpFdCQFZi0wFmiHpJiYMrbrBMYBRcwMiw
	ilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMwkE//e9a7g/H2AetDjMlA4yYyS4km5wMjIa8k
	3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGIvZ7mcU
	/SmL/JPJE3vuzxWLq8+y5+VNe5915WQr4/bUFRNvPnmfwmTXUmEzUf01957MZpvUSf5NqnP8
	zXa3WOxoXP/sfXPLxXX3lvjZ/r8br+S8vdhmc9W/bPsZvfbuC35etW11mHzz15ajDZ/NVs1Y
	dCWyZ12ar9VmO4sVimwNTDY3rszInqLEUpyRaKjFXFScCACilPA1egIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jQd19cz4GG8z4LWYx9eETNovrX56z
	Wsw/co7V4sCfHYwWr18YWpxtesNu8e1KB5PF5V1z2Cxa9x5hd+D02DnrLrvHplWdbB53ru1h
	8+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGbuWnWMs
	mMVTcXNzM3MD4zfOLkZODgkBE4nu728YIWwxiQv31rN1MXJxCAlMZ5RoO7WGFSQhJNDEJNH6
	CMxmE9CS2P/iBhuILQLUcHtOJzNIA7PAPUaJL6sfsoAkhAXCJB6seQ6U4OBgEVCV2HabCSTM
	K+AisW3iGhaIZXISH/Y8Yp/AyL2AkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCcPJPe
	wbiqweIQowAHoxIPr8frD8FCrIllxZW5hxglOJiVRHjXNX0MFuJNSaysSi3Kjy8qzUktPsRo
	CrR8IrOUaHI+MIbzSuINjU3MjCyNzA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFwSjUw
	ZiewzFO9fuHuNc/rYmbP465GLclhUVrG1Kb9MEGi+BqHueG9GyFZwfnnVvz8keB2XW2pQ8Tz
	t8ebFmQ3tDnv6+T7+W3aduUF6vKqRxwcK1aax4ud09jsqnI3MvTlG+875vpWli+vu3iK8KS0
	3L11d6cw2/rdT/VZ9rwxWJMkzmJ84cTczKkuSizFGYmGWsxFxYkA3WmRO6kCAAA=
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
		regulator-state-mem {
			regulator-off-in-suspend;
		};

		regulator-state-disk {
			regulator-volt = <1200000>;
			regulator-on-in-suspend;
		};
	};

Changes from v3:
- Don't support 'regulator-state-standby' mode
- Remove 'regulator-mode' property

Changes from v2:
- Fix over 80 lines by using checkpatch script
- Rebase this patchset on latest for-next branch of regulator.git

Changes from v1:
- Check whether regulator-initial-state and regulator-mode is correct or not
- Add more detailed description about regulator-initial-state, regulator-mode
  and regulator-state-[standby/mem/disk] for devicetree bindings
- Modify example of regulator suspend state in bindings documentation

Chanwoo Choi (2):
  regulator: of: Add support for parsing regulator_state for suspend state
  dt-bindings: regulator: Add regulator suspend state for PM state

 .../devicetree/bindings/regulator/regulator.txt    | 22 ++++++++
 drivers/regulator/of_regulator.c                   | 65 +++++++++++++++++++++-
 2 files changed, 85 insertions(+), 2 deletions(-)

-- 
1.8.0

