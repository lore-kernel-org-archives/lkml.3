Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbaHFKor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:44:47 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:47364 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaHFKop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:44:45 -0400
Date: Wed, 6 Aug 2014 11:44:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, "Gupta, Pekon\"" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140806104440.GC10136@lee--X1>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20140731164709.GK9030@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140731164709.GK9030@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Lee Jones wrote:
> On Wed, 02 Jul 2014, Brian Norris wrote:
> > On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:

[...]

> > > +	if (IS_ERR(pdata))
> > > +		return PTR_ERR(pdata);
> > > +
> > > +	ppdata.of_node = stm_of_get_partitions_node(np, 0);
> > 
> > So you only support a single bank, at chip-select 0? Is this a
> > hardware limitation, or simply software? You might consider whether this
> > needs to be noted in the DT binding too -- it currently suggests that
> > this can be plural.
> 
> Yes, only one bank.  Chip select is not possible.

Sorry, not only one bank.

We can have multiple banks, but only one chip.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
