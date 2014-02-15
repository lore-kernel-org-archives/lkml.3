Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaBOTWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:22:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaBOTWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:22:50 -0500
Date: Sat, 15 Feb 2014 11:24:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Alessandro Gardich <gremlin@gremlin.it>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH] RFC: MFD: driver for Atmel Microcontroller on iPaq h3xxx
Message-ID: <20140215192410.GC2280@kroah.com>
References: <1391175275-27347-1-git-send-email-linus.walleij@linaro.org>
 <CACRpkdb1LFP45Oy0YJ6DSHriSorvHacH=RRWb4LmZ286LJJX0g@mail.gmail.com>
 <20140210115318.GD22773@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210115318.GD22773@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:53:18AM +0000, Lee Jones wrote:
> > > This adds a driver for the Atmel Microcontroller found on the
> > > iPAQ h3xxx series. This device handles some keys, the
> > > touchscreen, and the battery monitoring.
> > 
> > Any opinions on this driver or should we queue it in MFD as-is?
> 
> I have no problem taking this through the MFD tree with Greg's nod.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
