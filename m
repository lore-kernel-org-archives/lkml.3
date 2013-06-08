Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3FHSyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 14:54:33 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43788 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3FHSyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 14:54:32 -0400
Date: Sat, 8 Jun 2013 19:54:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: DEC: remove unbuildable promcon.c
In-Reply-To: <1369909215.23034.39.camel@x61.thuisdomein>
Message-ID: <alpine.LFD.2.03.1306081950280.21418@linux-mips.org>
References: <1369909215.23034.39.camel@x61.thuisdomein>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Paul Bolle wrote:

> promcon.o is built if CONFIG_PROM_CONSOLE is set. But there's no Kconfig
> symbol PROM_CONSOLE, so promcon.c is unbuildable. Remove it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) There used to be a Kconfig symbol PROM_CONSOLE. But it was SPARC
> specific and it was removed in v2.6.32, see commit 09d3f3f0e0 ("sparc:
> Kill PROM console driver.").
> 
> 2) Actually, it seems that it has never been possible to set
> PROM_CONSOLE for MIPS ever since this file was added in v2.3.9. I guess
> no-one noticed because (what seems to be) comparable functionality is
> provided in arch/mips/dec/prom/console.c.

 Yeah, I think over the years the file mostly served documentation 
purposes.  Given that we've had (as you also noticed) a working early-boot 
console available:

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Thanks for this clean-up.

  Maciej
