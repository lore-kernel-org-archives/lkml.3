Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaDYMW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:22:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:48862 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaDYMWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:22:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,926,1389772800"; 
   d="scan'208";a="527274700"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Turquette <mturquette@linaro.org>
Cc: Len Brown <lenb@kernel.org>, Mika Westerberg <mika.westerberg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Loic Poulain <loic.poulain@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ACPI / LPSS: fractional divider clocks
Date: Fri, 25 Apr 2014 15:22:19 +0300
Message-Id: <1398428541-912-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This serie is about getting support for the m over n fractional
divisors that are available for SPI and UART in Intel LPSS. We will
need support for it with the UART.

Fractional dividers appear to be quite common so I'm suggesting a new
basic clk type for them in the first patch.


Heikki Krogerus (2):
  clk: new basic clk type for fractional divider
  ACPI / LPSS: Support for fractional divider clock

 drivers/acpi/acpi_lpss.c             |  37 ++++++++--
 drivers/clk/Makefile                 |   1 +
 drivers/clk/clk-fractional-divider.c | 132 +++++++++++++++++++++++++++++++++++
 include/linux/clk-provider.h         |  31 ++++++++
 4 files changed, 194 insertions(+), 7 deletions(-)
 create mode 100644 drivers/clk/clk-fractional-divider.c

-- 
2.0.0.rc0

