Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab3LDMEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:04:53 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64023 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3LDMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:04:51 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, horms@verge.net.au,
        Magnus Damm <magnus.damm@gmail.com>, tglx@linutronix.de
Date: Wed, 04 Dec 2013 21:05:37 +0900
Message-Id: <20131204120537.29642.942.sendpatchset@w520>
Subject: [PATCH 00/02] irqchip: renesas-irqc: Lazy disable and mask-on-suspend
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irqchip: renesas-irqc: Lazy disable and mask-on-suspend

[PATCH 01/02] irqchip: renesas-irqc: Use lazy disable
[PATCH 02/02] irqchip: renesas-irqc: Enable mask on suspend

Update the IRQC driver to use lazy disable and mask on suspend. This fixes
the Suspend-to-RAM behavior to make sure wakeup sources are left enabled
while suspending.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Written against renesas.git tag renesas-devel-v3.13-rc2-20131202

 drivers/irqchip/irq-renesas-irqc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)
