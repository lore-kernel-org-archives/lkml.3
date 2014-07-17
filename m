Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbaGQU5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:57:05 -0400
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:58396 "HELO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755360AbaGQU5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:57:03 -0400
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, jaswinder.singh@linaro.org, =devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 0/3] mailbox: Add APM X-Gene platform mailbox driver
Date: Thu, 17 Jul 2014 13:57:22 -0700
Message-Id: <1405630645-15337-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to add the APM X-Gene platform mailbox driver. The mailbox driver
is based off Jassi Brar's mailbox framework. This patch set is based off 
the following git.

https://github.com/sumananna/mailbox.git

Feng Kan (3):
  mailbox: add support for APM X-Gene platform mailbox driver
  Documentation: mailbox: Add APM X-Gene SlimPro mailbox dts
    documentation
  arm64: dts: mailbox device tree node for APM X-Gene platform.

 .../bindings/mailbox/xgene-slimpro-mailbox.txt     |  41 +++
 arch/arm64/boot/dts/apm-storm.dtsi                 |  14 +
 drivers/mailbox/Kconfig                            |  10 +
 drivers/mailbox/Makefile                           |   1 +
 drivers/mailbox/mailbox-xgene-slimpro.c            | 287 +++++++++++++++++++++
 5 files changed, 353 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt
 create mode 100644 drivers/mailbox/mailbox-xgene-slimpro.c

-- 
1.9.1

