Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbaCOPFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:05:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbaCOPFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:05:30 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v2 0/2] irqchip: sun4i: Use handle_fasteoi_irq for all irqs
Date: Sat, 15 Mar 2014 16:04:52 +0100
Message-Id: <1394895894-8891-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Here is v2 of my patchset for sun4i-irq.c to use handle_fasteoi_irq for all
irqs + follow up clean-up patch.

Changes since v2:
-adjust commit msg based on Thomas' comments, and merge patch 1 and 2 as
 they make more sense as 1 patch

Regards,

Hans
