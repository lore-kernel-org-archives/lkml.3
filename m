Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3IKMI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:08:58 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:46350 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3IKMI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:08:57 -0400
Date: Wed, 11 Sep 2013 21:08:16 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] input: ti_am335x_tsc: Enable shared IRQ for TSC
Message-ID: <20130911160815.GA9748@gmail.com>
References: <1378034277-26728-1-git-send-email-zubair.lutfullah@gmail.com>
 <1378034277-26728-2-git-send-email-zubair.lutfullah@gmail.com>
 <522C5F96.20001@kernel.org>
 <20130909161230.GA25107@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909161230.GA25107@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:12:30AM -0700, Dmitry Torokhov wrote:
> On Sun, Sep 08, 2013 at 12:29:26PM +0100, Jonathan Cameron wrote:
> > On 09/01/13 12:17, Zubair Lutfullah wrote:
> > > Enable shared IRQ to allow ADC to share IRQ line from
> > > parent MFD core. Only FIFO0 IRQs are for TSC and handled
> > > on the TSC side.
> > > 
> > > Step mask would be updated from cached variable only previously.
> > > In rare cases when both TSC and ADC are used, the cached
> > > variable gets mixed up.
> > > The step mask is written with the required mask every time.
> > > 
> > > Rachna Patil (TI) laid ground work for shared IRQ.
> > > 
> > > Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> > Whilst I would have prefered an mfd under these drivers and elegant handling
> > of the interrupts, I guess if this works it is at least not terribly invasive.
> > 
> > However, this does need an Ack from Dmitry before I can take it (or for
> > Dmitry to take it himself?)
> 
> I completely agree with Jonathan, more elegant handling would be nice
> but current one will do for now.
> 
> Since most of the work on the driver is going through IIO tree I think
> it would make sense for this patch to go through it as well.
> 
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thank-you.
ZubairLK

