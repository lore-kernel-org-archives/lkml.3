Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaI0XBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 19:01:30 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41429 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaI0XB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 19:01:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140922110425.2ec8a0af@bbrezillon>
Cc: "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1410797759-18675-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410797759-18675-2-git-send-email-alexandre.belloni@free-electrons.com>
 <541C228F.70207@atmel.com> <20140922110425.2ec8a0af@bbrezillon>
Message-ID: <20140927230105.19023.91442@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCHv3 1/7] clk: at91: add a driver for the h32mx clock
Date: Sat, 27 Sep 2014 16:01:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2014-09-22 02:04:25)
> On Fri, 19 Sep 2014 14:33:19 +0200
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
> > On 15/09/2014 18:15, Alexandre Belloni :
> > > Newer SoCs have two different AHB interconnect. The AHB 32 bits Matrix
> > > interconnect (h32mx) has a clock that can be setup at the half of the h64mx
> > > clock (which is mck). The h32mx clock can not exceed 90 MHz.
> > > 
> > > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > 
> > Okay on my side:
> > 
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > 
> > 
> > > ---
> > > Cc:Mike Turquette <mturquette@linaro.org>
> > 
> > Mike,
> > 
> > I guess that you didn't get this v3. Can you "Ack" this one of should we
> > re-sent to you?
> > 
> > I would like to take this patch with the rest of the SAMA5D4 series: is
> > it okay for you?
> 
> 
> Hi Mike,
> 
> I gave my ack to this patch, so, if you don't mind letting Nicolas
> take it through his tree, I think it will ease integration of the
> sama5d4 support (no external dependencies on the clk tree).

Acked-by: Mike Turquette <mturquette@linaro.org>

> 
> Best Regards,
> 
> Boris
> 
> -- 
> Boris Brezillon, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com
