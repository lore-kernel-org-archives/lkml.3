Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3KNMdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:33:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:58806 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3KNMdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:33:22 -0500
Date: Thu, 14 Nov 2013 13:33:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sricharan R <r.sricharan@ti.com>
cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, tony@atomide.com, rnayak@ti.com,
        marc.zyngier@arm.com, grant.likely@linaro.org, mark.rutland@arm.com,
        robherring2@gmail.com, galak@codeaurora.org, rob.herring@calxeda.com,
        nm@ti.com, bcousson@baylibre.com
Subject: Re: [PATCH V4 1/4] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable
 irqs
In-Reply-To: <1384431530-2166-2-git-send-email-r.sricharan@ti.com>
Message-ID: <alpine.DEB.2.02.1311141332350.30673@ionos.tec.linutronix.de>
References: <1384431530-2166-1-git-send-email-r.sricharan@ti.com> <1384431530-2166-2-git-send-email-r.sricharan@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013, Sricharan R wrote:
>  [V3] Addressed unnecessary warn-on and updated default
>       xlate function as per Thomas Gleixner comments

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
