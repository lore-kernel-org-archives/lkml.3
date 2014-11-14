Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965720AbaKNSaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:30:25 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62768 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbaKNSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:30:21 -0500
X-IronPort-AV: E=Sophos;i="5.07,387,1413270000"; 
   d="scan'208";a="50929490"
From: Scott Branden <sbranden@broadcom.com>
To: Scott Branden <sbranden@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Ray Jui <rjui@broadcom.com>, Arun Ramamurthy <arunrama@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] pwm: kona: Drivers fixes
Date: Fri, 14 Nov 2014 10:29:56 -0800
Message-ID: <1415989800-7515-1-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <Scott Branden <sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains fixes for Broadcom's Kona PWM driver.

These changes fix glitch issues when changing settings on different channels.
Kconfig change made to allow the driver to work on any Broadcom SoC rather
than just mobile devices.

Arun Ramamurthy (4):
  pwm: kona: Remove setting default smooth type and polarity for all
    channels
  pwm: kona: Fix incorrect enable after channel polarity change
  pwm: kona: Fix enable, disable and config procedures
  pwm: kona: Update dependency to ARCH_BCM

 drivers/pwm/Kconfig        |   2 +-
 drivers/pwm/pwm-bcm-kona.c | 112 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 81 insertions(+), 33 deletions(-)

-- 
2.1.3

