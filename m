Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3GAVmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:42:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:57330 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GAVmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:42:24 -0400
Date: Mon, 1 Jul 2013 23:42:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: linux-kernel@vger.kernel.org, Kirill Tkhai <tkhai@yandex.ru>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/5] metag: smp: enable irqs after set_cpu_online
In-Reply-To: <1372694659-30176-3-git-send-email-james.hogan@imgtec.com>
Message-ID: <alpine.DEB.2.02.1307012342030.4013@ionos.tec.linutronix.de>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com> <1372694659-30176-3-git-send-email-james.hogan@imgtec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, James Hogan wrote:

> In secondary_start_kernel() interrupts should be enabled with
> local_irq_enable() after the cpu is marked as online with
> set_cpu_online(). Otherwise it's possible for a timer interrupt to
> trigger a softirq, which if the cpu is marked as offline may have it's
> affinity altered.
> 
> Reported-by: Kirill Tkhai <tkhai@yandex.ru>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Kirill Tkhai <tkhai@yandex.ru>
> Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
