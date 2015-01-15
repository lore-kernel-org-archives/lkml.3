Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbbAOJOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:14:44 -0500
Received: from down.free-electrons.com ([37.187.137.238]:51537 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbbAOJOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:14:41 -0500
Date: Thu, 15 Jan 2015 10:14:08 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
Cc: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/6] ARM: at91: pm: use the mmio-sram pool to access SRAM
Message-ID: <20150115091408.GR3843@piout.net>
References: <1421097825-396-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421097825-396-3-git-send-email-alexandre.belloni@free-electrons.com>
 <B256D81BAE5131468A838E5D7A243641BFCDFFBB@penmbx01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B256D81BAE5131468A838E5D7A243641BFCDFFBB@penmbx01>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Thank you for your review.

On 15/01/2015 at 08:53:54 +0000, Yang, Wenyou wrote :
> >  config AT91_SLOW_CLOCK
> >  	bool "Suspend-to-RAM disables main oscillator"
> > +	select SRAM
> Can we move it under config ARCH_AT91 or other place?
> 
> It may be used for other purposes, more than pm. I thinks
> 

I believe it is better if every SRAM user selects SRAM so that when you
don't have any of those, it is not automatically selected and it reduces
the kernel size.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
