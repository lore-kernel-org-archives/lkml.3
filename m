Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbbAMWzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:55:23 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52299 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751646AbbAMWzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:55:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+4sHbK9ZDbXQiWOrVNsuPw
From: Tony Lindgren <tony@atomide.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 0/2] Minimal FAPLL clock support for dm816x
Date: Tue, 13 Jan 2015 14:51:26 -0800
Message-Id: <1421189488-9657-1-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a minimal support for the FAPLL (Flying Adder PLL) on dm816x
which is a omap variant.

Regards,

Tony


Tony Lindgren (2):
  clk: ti: Add support for FAPLL on dm816x
  clk: ti: Initialize clocks for dm816x

 .../devicetree/bindings/clock/ti/fapll.txt         |  33 ++
 drivers/clk/ti/Makefile                            |   1 +
 drivers/clk/ti/clk-3xxx.c                          |   8 +-
 drivers/clk/ti/clk-816x.c                          |  53 +++
 drivers/clk/ti/fapll.c                             | 410 +++++++++++++++++++++
 5 files changed, 498 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/ti/fapll.txt
 create mode 100644 drivers/clk/ti/clk-816x.c
 create mode 100644 drivers/clk/ti/fapll.c

-- 
2.1.4

