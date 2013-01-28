Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3A1PcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:32:04 -0500
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:50485 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab3A1PcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:32:01 -0500
Date: Mon, 28 Jan 2013 19:31:56 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: gregkh@linuxfoundation.org, panto@antoniou-consulting.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] w1-gpio: fix section mismatch
Message-ID: <20130128153156.GB9089@ioremap.net>
References: <1359317277-29161-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359317277-29161-1-git-send-email-hauke@hauke-m.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Jan 27, 2013 at 09:07:57PM +0100, Hauke Mehrtens (hauke@hauke-m.de) wrote:
> This fixes the following section mismatch:
> 
> WARNING: drivers/w1/masters/w1-gpio.o(.data+0x188): Section mismatch in
> reference from the variable w1_gpio_driver to the function
> .init.text:w1_gpio_probe()
> The variable w1_gpio_driver references
> the function __init w1_gpio_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Looks good to me
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
