Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaLJQWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:22:09 -0500
Received: from www.linutronix.de ([62.245.132.108]:54611 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726AbaLJQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:22:07 -0500
Date: Wed, 10 Dec 2014 17:22:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [question] on which cpu an interrupt controller will raise an
 irq ?
In-Reply-To: <5484BBC8.7080304@linaro.org>
Message-ID: <alpine.DEB.2.11.1412101721070.13233@nanos>
References: <5484BBC8.7080304@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Dec 2014, Daniel Lezcano wrote:
> I am not very familiar with the interrupt subsystem, so sorry if this sounds a
> stupid question.
> 
> IIUC, when a interrupt happens on a SMP system and if there is no affinity set
> for it, it is delivered following a scheme decided by the interrupt
> controller.
> 
> For example, for the APIC, there is a round robin behaviour, so an interrupt
> will be raised on cpu0, then cpu1, and so on ...
> 
> Is there a way to know on which cpu a controller will raise the interrupt ?

No generic way which would allow to predict it on every controller we
support.

Thanks,

	tglx
