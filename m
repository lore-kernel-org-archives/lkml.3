Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3EMIVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:21:00 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:61745 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3EMIU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:20:57 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 0/2] clk: vt8500: updates for 3.11
Date: Mon, 13 May 2013 20:20:58 +1200
Message-Id: <1368433260-16073-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Two updates for the arch-vt8500 clock code:

#1: Add support for the WM8850 PLL.
#2: Remove a second divisor check in vt8500_dclk_set_rate() which causes the
divisor to be round-down too low.

Regards
Tony Prisk

Tony Prisk (2):
  clk: vt8500: Add support for clocks on the WM8850 SoCs
  clk: vt8500: Remove unnecessary divisor adjustment in
    vtwm_dclk_set_rate()

 Documentation/devicetree/bindings/clock/vt8500.txt |    2 +
 drivers/clk/clk-vt8500.c                           |   75 ++++++++++++++++++--
 2 files changed, 73 insertions(+), 4 deletions(-)

-- 
1.7.9.5

