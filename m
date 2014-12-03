Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaLCSKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:10:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21995 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaLCSKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:10:49 -0500
Date: Wed, 3 Dec 2014 21:10:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sean Cleator <seancleator@hotmail.co.uk>, lidza.louina@gmail.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging: dgnc: Fix long line coding style issues in
 dgnc_cls.h
Message-ID: <20141203181044.GM4994@mwanda>
References: <BLU437-SMTP66508C574F65742CE8FCDEE97B0@phx.gbl>
 <20141203173441.GA12889@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203173441.GA12889@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 09:34:41AM -0800, Greg KH wrote:
> > +#define UART_IIR_CTSRTS			0x20	/*
> > +						 *  Received CTS/RTS change of
> > +						 *  state
> > +						 */
> 
> That's pretty ugly, don't you think?  How about putting the comments on
> the line before the #define, instead of at the end?  That would make
> things much nicer to read.
> 

I was going to say the same thing but it looks worse in the mail client
because of how the tabs work out.  In the code it doesn't look terrible.

#define UART_IIR_CTSRTS			0x20	/*
						 *  Received CTS/RTS change of
						 *  state
						 */

Another idea would be to just remove a tab.  It wouldn't align with the
section before but it would align with the next section down.

regards,
dan carpenter

