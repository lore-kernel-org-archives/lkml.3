Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbbAMW1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:27:19 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10734 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbbAMW1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:27:17 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19UdE4skEj9j65CmG/7871A
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 0/2] Add support for dm81xx to omap intc, remove unused legacy support
Date: Tue, 13 Jan 2015 14:23:24 -0800
Message-Id: <1421187806-6804-1-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a patch to get the ti81xx interrupt support working properly,
and to remove some unused legacy code.

Regards,

Tony

clone of "xxx-81xx-mainline"

Tony Lindgren (2):
  irqchip: omap-intc: Fix support for dm814 and dm816
  irqchip: omap-intc: Remove unused legacy interface for omap2

 .../interrupt-controller/ti,omap-intc-irq.txt      | 28 ++++++++++++++++++++++
 drivers/irqchip/irq-omap-intc.c                    | 22 ++++-------------
 include/linux/irqchip/irq-omap-intc.h              |  2 --
 3 files changed, 33 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/ti,omap-intc-irq.txt

-- 
2.1.4

