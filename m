Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaILDSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:18:48 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:54623 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaILDSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:18:47 -0400
From: Sean Cross <xobs@kosagi.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Cc: bunnie@kosagi.com, Sean Cross <xobs@kosagi.com>
Subject: [PATCH v2 0/2] Add irq_over_gpio DT support to STMPE
Date: Fri, 12 Sep 2014 11:18:32 +0800
Message-Id: <1410491914-23378-1-git-send-email-xobs@kosagi.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for using a GPIO as an IRQ source for the
STMPE module when configured using device tree.

Changes since v1:
    - Split actual patch and Documentation into two parts

Sean Cross (2):
  mfd: stmpe: support gpio over irq under device tree
  mfd: stmpe: Document DT binding for irq_over_gpio

 Documentation/devicetree/bindings/mfd/stmpe.txt | 1 +
 drivers/mfd/stmpe.c                             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.1.0

