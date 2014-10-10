Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaJJLfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:35:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56311 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJJLfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:35:41 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-d4-5437c48ab322
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, javier@dowhile0.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 0/3] regulator: of: Add support for parsing regulator suspend
 state
Date: Fri, 10 Oct 2014 20:35:32 +0900
Message-id: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkQLfriHmIwbX54hZTHz5hs7j+5Tmr
	xfwj51gtDvzZwWhx7fcMNouzTW/YLb5d6WCyuLxrDptF694j7A6cHn9ntzJ77Jx1l91j06pO
	No871/awefRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfG/v7F7AWHhCvePOxkamD8xd/FyMkh
	IWAiseHgWWYIW0ziwr31bF2MXBxCAksZJXaf2sXSxcgBVnRiIhdEfBGjRM+iN1BFTUwSj37u
	A+tmE9CS2P/iBhuILQI06facTmaQImaBG4wSB7YvA5skLBAusfuwOkgNi4CqxKa521lBbF4B
	V4m9O4+yQ1whJ/FhzyN2kF4JgensErdmd7NBNAhIfJt8COoiWYlNB6CulpQ4uOIGywRGwQWM
	DKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAoP69L9nE3Yw3jtgfYhRgINRiYf3gox5iBBr
	YllxZe4hRlOgDROZpUST84Gxk1cSb2hsZmRhamJqbGRuaaYkzvta6mewkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBsZozrcqWxKn1tz9+lZm0dv9tetytp5T3MF3/7jR0kVVNiwKU1n4/oQH
	LQ6PeDdj7p1lvyac5D9yMcnoadfL7WkFf9gtdoTeXOT9/+dPpYDFv1k2T727RK8prth2k3Bu
	8aMUFU8XXeHEDQweF31k9qozSKtI/9mVpVQrmeUZd19RbLum+Ir2hwpKLMUZiYZazEXFiQCa
	yn1lZQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t9jAd2uI+YhBue/8llMffiEzeL6l+es
	FvOPnGO1OPBnB6PFtd8z2CzONr1ht/h2pYPJ4vKuOWwWrXuPsDtwevyd3crssXPWXXaPTas6
	2TzuXNvD5tG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlAZykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsY
	M/b3L2YvOCRc8eZhJ1MD4y/+LkYODgkBE4kTE7m6GDmBTDGJC/fWs3UxcnEICSxilOhZ9AbK
	aWKSePRzHzNIFZuAlsT+FzfYQGwRoI7bczqZQYqYBW4wShzYvowFZKqwQLjE7sPqIDUsAqoS
	m+ZuZwWxeQVcJfbuPMoOsU1O4sOeR+wTGLkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/d
	xAiOmWfSOxhXNVgcYhTgYFTi4b0gYx4ixJpYVlyZe4hRgoNZSYR3/l6gEG9KYmVValF+fFFp
	TmrxIUZToO0TmaVEk/OB8ZxXEm9obGJmZGlkbmhhZGyuJM57sNU6UEggPbEkNTs1tSC1CKaP
	iYNTqoGx+EzJlh0vZXYLneyV+2+YOF9e9538Ca5LO///qO6s0Q/Oe+obcjSsb1ewS7HJP+nZ
	nybOc8l+GiwaIWfR1iPLIbTxyaykvGkr882Zek/ke04JXXdkUQN37X4z86SZUtu2lsj3Oy+c
	eGvvllLLBVM50y1+XF/lkvZa6vWq5b48sxZJXWz9E+CvxFKckWioxVxUnAgASYIIpa8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulators would set different state/mode according to the kind of suspend
state. So regulation_constraints structure has already regulator suspend state filed.
This patch parse regulator suspend state from devicetree file.

I tested this patch on Rinato board (Samsung Gear 2) included S2MPS14 PMIC.
- The power-consumption in suspend state is 0.6mA after applied this patchset.

For example:
	ldoX_reg: LDOx {
		regulator-name = "VAP_XXX_1.2V";
		regulator-min-microvolt = <1200000>;
		regulator-max-microvolt = <1200000>;
		regulator-always-on;

		regulator-state-mem {
			regulator-off-in-suspend;
		};
	};

Changes from v4:
- Rebase this patchset on for-next branch of regulator.git
- Remove 'regulator-volt' property
- Remove 'regulator-initial-state' property
- Add example patch[1, patch3] based on Rinato board[2] included S2MPS14 PMIC.
  S2MPS14 PMIC patch[3] has already implemented '.set_suspend_disable()' func
  to change the regulator state to reduce power-consumption in suspend-state.
  [1] ARM: dts: Add sleep mode of regulator for exynos3250-rinato board
  [2] http://www.spinics.net/lists/linux-samsung-soc/msg37636.html
      - [PATCHv2 0/2] ARM: dts: Add new board dts file for Exynos3250-based Rinato board
      - This patchset is not yet merged.
  [3] regulator: s2mps11: Add set_suspend_disable for S2MPS14
      (commid id: 05be09bb5ec8d12051515087a1983745dc93d906)

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

Chanwoo Choi (3):
  regulator: of: Add support for parsing regulator_state for suspend state
  dt-bindings: regulator: Add regulator suspend state for PM state
  ARM: dts: Add sleep mode of regulator for exynos3250-rinato board

 .../devicetree/bindings/regulator/regulator.txt    |  13 +++
 arch/arm/boot/dts/exynos3250-rinato.dts            | 108 +++++++++++++++++++++
 drivers/regulator/of_regulator.c                   |  39 +++++++-
 3 files changed, 159 insertions(+), 1 deletion(-)

-- 
1.8.0

