Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaGGRDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:03:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59290 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751224AbaGGRDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:03:23 -0400
Date: Mon, 7 Jul 2014 19:03:20 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] Add a driver for the atmel ram controller
Message-ID: <20140707190320.500e67c2@bbrezillon>
In-Reply-To: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre,

On Mon,  7 Jul 2014 17:19:10 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> The atmel ram controller needs one or more clocks to work. For now the
> CLK_IGNORE_UNUSED flag is used on those clocks. This patch set introduce a
> driver that will take care of taking those clocks.
> 
> The final goal is also to move the ioremap done in mach-at91 to that driver with
> a proper power management driver.
> 
>Apart from the minor comments I made on patch 1, you have my

Acked-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

That's great to see the dirty CLK_IGNORE_UNSUSED hack removed in favor
of this SDRAM controller driver approach.

Thanks,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
