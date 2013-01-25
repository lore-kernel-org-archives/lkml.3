Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3AYUZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:25:13 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44884 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3AYUZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:25:10 -0500
Date: Fri, 25 Jan 2013 12:25:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
Message-ID: <20130125202507.GB5470@kroah.com>
References: <CACRpkdYSaFsastx-WWC7sBu8NteAc2hCDZMz4-yMc8+=2dyBVw@mail.gmail.com>
 <50f107aa.894e420a.596a.ffffe3f6SMTPIN_ADDED_BROKEN@mx.google.com>
 <CACRpkdaJd48WOzP_iURATb=c+V6==2-AB2Y9oFyh=E3oe1eT0Q@mail.gmail.com>
 <20130114002608.GV23505@n2100.arm.linux.org.uk>
 <CACRpkdbVPeva08nL_FP7qw0MeKLz6h40kPHAz_W95ZBGraOnpg@mail.gmail.com>
 <CAOAMb1BgcvBb6KHaZbwbh0rq8r1WfAtdCeZJexfaYoOwGfU7Sg@mail.gmail.com>
 <CAOAMb1BS6gvezeSrUTNJ--gGxCRL17AO8PHJ_eLrxzjOex7w1g@mail.gmail.com>
 <CAOAMb1C=b2fXqKJKx1ZR7UD7n=c7qQoLnMgMmy2FXEubyP=dtw@mail.gmail.com>
 <CACRpkdYt8CoF0_yrMkNE20fhKnRuG-=yxr2XsQKPgMWD=ehUNA@mail.gmail.com>
 <CAOAMb1ACPx6iXWDYz7LnrbRLkLmK9HU7Lro7H5gqpSKr24ooVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAMb1ACPx6iXWDYz7LnrbRLkLmK9HU7Lro7H5gqpSKr24ooVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 02:07:57PM +0900, Chanho Min wrote:
> On Tue, Jan 22, 2013 at 10:18 PM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
> >> - If poll timer is activated, We use consistent DMA mappings to avoid from
> >>   the frequent cache operation of the timer function. sg->coherency is used
> >>   to check if buffer is coherent.
> >
> > Hm. We can begin like this but maybe we should later patch it to
> > make this the default unless it has performance impacts on our
> > systems.
> Good, I really hope to make this the default.
> We expect it has no impact to system even if no polling use.
> 
> > Maybe this is a good opportunity to add some kerneldoc above
> > this struct so as to help platform implementers. It will invariably
> > be reused by Device Tree binding authors later on...
> Agree, but, frankly I need help about what I didn't modify.
> So We will leave this work for the next submit.

So, should this patch be applied?  Can I get an ack from someone who
knows this driver/platform please?

thanks,

greg k-h
