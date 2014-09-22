Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaIVJE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:04:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46841 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbaIVJE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:04:28 -0400
Date: Mon, 22 Sep 2014 11:04:25 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 1/7] clk: at91: add a driver for the h32mx clock
Message-ID: <20140922110425.2ec8a0af@bbrezillon>
In-Reply-To: <541C228F.70207@atmel.com>
References: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1410797759-18675-2-git-send-email-alexandre.belloni@free-electrons.com>
	<541C228F.70207@atmel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 14:33:19 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> On 15/09/2014 18:15, Alexandre Belloni :
> > Newer SoCs have two different AHB interconnect. The AHB 32 bits Matrix
> > interconnect (h32mx) has a clock that can be setup at the half of the h64mx
> > clock (which is mck). The h32mx clock can not exceed 90 MHz.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Okay on my side:
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> 
> > ---
> > Cc:Mike Turquette <mturquette@linaro.org>
> 
> Mike,
> 
> I guess that you didn't get this v3. Can you "Ack" this one of should we
> re-sent to you?
> 
> I would like to take this patch with the rest of the SAMA5D4 series: is
> it okay for you?


Hi Mike,

I gave my ack to this patch, so, if you don't mind letting Nicolas
take it through his tree, I think it will ease integration of the
sama5d4 support (no external dependencies on the clk tree).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
