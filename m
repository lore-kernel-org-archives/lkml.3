Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab3FXT4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:56:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:51551 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3FXT4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:56:35 -0400
Date: Mon, 24 Jun 2013 21:56:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 24/32] clocksource+irqchip: delete __cpuinit usage from
 all related files
In-Reply-To: <1372102237-8757-25-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <alpine.DEB.2.02.1306242156150.4013@ionos.tec.linutronix.de>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com> <1372102237-8757-25-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Paul Gortmaker wrote:

> The __cpuinit type of throwaway sections might have made sense
> some time ago when RAM was more constrained, but now the savings
> do not offset the cost and complications.  For example, the fix in
> commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> is a good example of the nasty type of bugs that can be created
> with improper use of the various __init prefixes.
> 
> After a discussion on LKML[1] it was decided that cpuinit should go
> the way of devinit and be phased out.  Once all the users are gone,
> we can then finally remove the macros themselves from linux/init.h.
> 
> This removes all the drivers/clocksource and drivers/irqchip uses of
> the __cpuinit macros from all C files.
> 
> [1] https://lkml.org/lkml/2013/5/20/589
> 
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
 
