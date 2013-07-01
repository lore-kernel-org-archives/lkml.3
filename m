Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3GAV7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:59:39 -0400
Received: from cynthia.allandria.com ([76.245.85.235]:33014 "EHLO
	cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3GAV7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:59:38 -0400
Date: Mon, 1 Jul 2013 14:59:32 -0700
From: Brad Boyer <flar@cynthia.pants.nu>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k/mac: Allocate IOP message pool and queues
 dynamically
Message-ID: <20130701215932.GA12663@cynthia.pants.nu>
References: <1372586542-1318-1-git-send-email-geert@linux-m68k.org>
 <alpine.LNX.2.00.1307011325520.9968@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1307011325520.9968@nippy.intranet>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 05:46:48PM +1000, Finn Thain wrote:
> 
> On Sun, 30 Jun 2013, Geert Uytterhoeven wrote:
> 
> > -
> > -/*
> > - * Register the interrupt handler for the IOPs.
> > - * TODO: might be wrong for non-OSS machines. Anyone?
> > - */
> > -
> > -void __init iop_register_interrupts(void)
> > -{
> > -	if (iop_ism_present) {
> > +		/*
> > +		 * Register the interrupt handler for the IOPs.
> > +		 * TODO: might be wrong for non-OSS machines. Anyone?
> 
> My testing with a non-OSS machine (Quadra 950) indicates that the TODO is 
> obsolete. And the comment "register the interrupt handler for the IOPs" is 
> a bit silly. It merely re-phrases the code. Otherwise, this patch looks 
> good to me. Thanks.

The code was all originally written and tested only on the IIfx. That's
all JMT had, and at the time it was all I had as well. I have since
acquired a Quadra 950. Lots of these comments are just out of date. I
know it got tested on either a Quadra 900 or Quadra 950 after that
comment was put in the source.

	Brad Boyer
	flar@allandria.com

