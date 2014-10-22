Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbaJVJim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:38:42 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:41980 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545AbaJVJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:38:38 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/3] ARM: shmobile: r8a7740/armadillo800eva dts: Enable TMU0
Date: Wed, 22 Oct 2014 11:38:26 +0200
Message-Id: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

It seems the TMU got lost from armadillo800eva-reference at some point
in time, and thus the conversion to DT was forgotten.
This series extends the existing bindings to cover r8a7740, adds the device
nodes on r8a7740, and enables TMU0 on armadillo800eva-multiplatform.

Geert Uytterhoeven (3):
  clocksource: sh_tmu: Document R-Mobile r8a7740 binding
  ARM: shmobile: r8a7740 dtsi: Add TMU0 and TMU1 device nodes
  ARM: shmobile: armadillo800eva dts: Enable TMU0

 .../devicetree/bindings/timer/renesas,tmu.txt      |  3 ++-
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts      |  4 ++++
 arch/arm/boot/dts/r8a7740.dtsi                     | 28 ++++++++++++++++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
