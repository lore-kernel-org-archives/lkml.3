Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaDOKGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:06:22 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47605 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaDOKGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:06:18 -0400
Date: Tue, 15 Apr 2014 11:06:14 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Jamie Iles <jamie@jamieiles.com>, Richard Weinberger <richard@nod.at>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: remove unbuildable picoxcell TRNG
Message-ID: <20140415100614.GA2037@page.Home>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-7-git-send-email-richard@nod.at>
 <1391977683.25855.27.camel@x220>
 <1397552118.1985.16.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397552118.1985.16.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Apr 15, 2014 at 10:55:18AM +0200, Paul Bolle wrote:
> The driver for the "Picochip picoXcell true random number generator" was
> added in v2.6.39. Its Kconfig symbol has always depended on
> PICOXCELL_PC3X3. But that Kconfig symbol has never been part of the
> tree. This means this driver has never been buildable. Let's remove it.
> It can be re-added if its dependencies are actually part of the tree.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

I wish I had the bandwidth to get this properly supported, but this 
seems sensible to me.

Acked-by: Jamie Iles <jamie@jamieiles.com>

Thanks,

Jamie
