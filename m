Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3FRNlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:41:09 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:34271 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3FRNlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:41:08 -0400
Date: Tue, 18 Jun 2013 15:41:04 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, tglx@linutronix.de, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: irqchip: add support for MOXA ART SoCs
Message-ID: <20130618154104.7f8115c7@skate>
In-Reply-To: <1371549584-7169-1-git-send-email-jonas.jensen@gmail.com>
References: <1371549584-7169-1-git-send-email-jonas.jensen@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jonas Jensen,

On Tue, 18 Jun 2013 11:59:44 +0200, Jonas Jensen wrote:

> +asmlinkage void __exception_irq_entry moxart_handle_irq(struct pt_regs *regs);

This forward declaration could be removed if moxart_handle_irq() was
implemented before the initialization function of your driver.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
