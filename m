Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaC2JIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 05:08:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40266 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751186AbaC2JH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 05:07:58 -0400
Date: Sat, 29 Mar 2014 10:07:56 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 05/10] ARM: at91: make use of the new AIC driver
 for dt enabled boards
Message-ID: <20140329100756.272c978d@skate>
In-Reply-To: <1396029548-10928-6-git-send-email-b.brezillon.dev@gmail.com>
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
	<1396029548-10928-6-git-send-email-b.brezillon.dev@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Boris BREZILLON,

On Fri, 28 Mar 2014 18:59:03 +0100, Boris BREZILLON wrote:

> +config ATMEL_AIC_IRQ
> +	bool
> +	default USE_OF
> +	select GENERIC_IRQ_CHIP
> +	select IRQ_DOMAIN
> +	select MULTI_IRQ_HANDLER

This option should probably go in drivers/irqchip/Kconfig, no?

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
