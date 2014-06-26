Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbaFZBFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:05:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:37394 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbaFZBFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:05:41 -0400
Date: Thu, 26 Jun 2014 03:05:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Kan <fkan@apm.com>
cc: jason@lakedaemon.net, marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
        patches@apm.com, Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH V2 2/2] irqchip: gic: preserve gic V2 bypass bits in cpu
 ctrl register
In-Reply-To: <1403734041-5112-3-git-send-email-fkan@apm.com>
Message-ID: <alpine.DEB.2.10.1406260302510.5170@nanos>
References: <1403734041-5112-1-git-send-email-fkan@apm.com> <1403734041-5112-3-git-send-email-fkan@apm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Feng Kan wrote:

> This change is made to preserve the GIC v2 bypass bits in the
> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
> This code will preserve all bits configured by the bootloader regarding
> v2 bypass group bits. In the X-Gene platform, the bypass functionality
> is not used and bypass bits should not be changed by the kernel gic
> code as it could lead to incorrect behavior.
> 
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Signed-off-by: Feng Kan <fkan@apm.com>

Who wrote the patch? According to the SOB chain it's Vinayak, but your
patch is missing the:

From: Vinayak Kale <vkale@apm.com>

before the actual changelog starts. 
