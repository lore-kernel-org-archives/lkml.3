Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaHRQ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:57:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56614 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaHRQ5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:57:19 -0400
From: Nishanth Menon <nm@ti.com>
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] clk: ti: Fix up error checks in set_rate (and div 0 error)
Date: Mon, 18 Aug 2014 11:56:53 -0500
Message-ID: <1408381015-16042-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The following patches are based on v3.17-rc1
Prior to this series: http://slexy.org/view/s20QH6PW4x (notice the /0 div error spam at initial boot log)
After this series: http://slexy.org/view/s20tPNXPf4

Nishanth Menon (2):
  clk: ti: divider: Provide error check for incoming parameters in
    set_rate
  clk: ti: dra7-atl: Provide error check for incoming parameters in
    set_rate

 drivers/clk/ti/clk-dra7-atl.c |    6 +++++-
 drivers/clk/ti/divider.c      |    7 ++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

-- 
1.7.9.5

