Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbaBFVOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:14:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:38120 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaBFVOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:14:36 -0500
Date: Thu, 6 Feb 2014 22:14:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Carlo Caione <carlo@caione.org>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, maxime.ripard@free-electrons.com,
        hdegoede@redhat.com, emilio@elopez.com.ar
Subject: Re: [PATCH] irq: Add new flag to ack level-triggered interrupts
 before unmasking
In-Reply-To: <1391721117-27446-1-git-send-email-carlo@caione.org>
Message-ID: <alpine.DEB.2.02.1402062213590.21991@ionos.tec.linutronix.de>
References: <1391721117-27446-1-git-send-email-carlo@caione.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Carlo Caione wrote:

> Several irqchip drivers require the level-triggered interrupt to be
> acked before unmasking to avoid that a second interrupt is immediately
> triggered. This small patch introduces a new irqchip flags that is used
> to ack the IRQ line before it is unmasked.

And why are you not doing this in the unmask function of the affected
chip in the first place?
 
Thanks,

	tglx
