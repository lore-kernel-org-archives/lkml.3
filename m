Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaBMIyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:54:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:48877 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751348AbaBMIyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:54:11 -0500
Date: Thu, 13 Feb 2014 09:54:09 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 3/8] at91: dt: Add at91sam9261 dt SoC support
Message-ID: <20140213085409.GH11498@piout.net>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
 <1392199607-27452-4-git-send-email-jjhiblot@traphandler.com>
 <20140212172844.GE11498@piout.net>
 <CACh+v5MgYB+L6vpektjAE1yTH=dvjnyP1CjJeA7vG_yOyxFkgg@mail.gmail.com>
 <52FC7E0E.2010503@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FC7E0E.2010503@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/02/2014 at 09:10:54 +0100, Nicolas Ferre wrote :
> On 12/02/2014 20:47, Jean-Jacques Hiblot :
> >>
> >> You probably copied/pasted it but according to the block diagram, the
> >> sdram controller is not under the apb.
> > You're right I copied/pasted :o) But the addresses of the registers
> > look like typical APB addresses.
> > AFAIK all the registers of this SOC are accessed through the APB
> > (except for OHCI and LCDC)
> 
> Yes, that is the point: if the register bank appears as an APB address,
> I place it on the APB bus.
> The other master interfaces (on AHB) are the ones that the IP uses, not
> us from the CPU point of view...
> 
> So I think that Jean-Jacques DT is okay concerning this.
> 


Ok, I'm perfectly fine with that. Thanks for the answer !

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
