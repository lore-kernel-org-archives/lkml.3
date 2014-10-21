Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaJUIZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:25:33 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16270 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaJUIZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:25:28 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-dc-5446187479fe
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/2] regulator: max77686/trats2: Disable some regulators in
 suspend
Date: Tue, 21 Oct 2014 10:25:10 +0200
Message-id: <1413879912-26606-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t/xy7olEm4hBv/faltsnLGe1WLSugNM
	FlMfPmGzuP7lOavF0d8FFq9fGFr0LrjKZnG26Q27xbcrHUwWmx5fY7W4vGsOm8WM8/uYLG5f
	5rVYe+Quu8WqXX8YHfg9Wpp72Dz+Pr/O4vF31Qtmj52z7rJ7bFrVyeaxeUm9R9+WVYwenzfJ
	BXBEcdmkpOZklqUW6dslcGW8WjiBteA8a8XGK+/ZGhgPsnQxcnJICJhI/Gi8CWWLSVy4t54N
	xBYSWMoo8X4SaxcjF5DdxyTxZekLdpAEm4CxxOblS9hAEiICC5kkju/8zQTiMAtcYJLY9OwP
	2ChhgVCJdSuPM4HYLAKqEp9OT2cEsXkF3CV+dZ9lhFgnJ3Hy2GTWCYzcCxgZVjGKppYmFxQn
	peca6hUn5haX5qXrJefnbmKEhOOXHYyLj1kdYhTgYFTi4d2wzDVEiDWxrLgy9xCjBAezkghv
	rrBbiBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG7ewTs3V13s6vOLT14N19Fzzel7DPXO7JcnC2
	0Rdl/1W3T9wud/591nqDvF36r7DPP+f86/+z98J6rXPXL73j0p7D+KxOrcHz66u5PsusC9wf
	Lpu+YJbevHmdV/PzfDeLvuH//2iJ88Ri9dXRr3UPbHglobBqymopGXn9qi8zL09/m16YEp2g
	6KbEUpyRaKjFXFScCAAEzQHQJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset makes use of Javier Martinez Cainllas changes [1].
It allows disabling some of the regulators during suspend to RAM.

Javier's patchset is necessary only to test it.

[1] [PATCH v3 0/2] ARM: EXYNOS: Call regulator suspend prepare/finish
    https://lkml.org/lkml/2014/10/20/545

Best regards,
Krzysztof

Krzysztof Kozlowski (2):
  regulator: max77686: Implement suspend disable for some LDOs
  ARM: dts: exynos4412-trats: Add suspend configuration for max77686
    regulators

 arch/arm/boot/dts/exynos4412-trats2.dts | 135 +++++++++++++++++++++++++-------
 drivers/regulator/max77686.c            |  19 +++++
 2 files changed, 124 insertions(+), 30 deletions(-)

-- 
1.9.1

