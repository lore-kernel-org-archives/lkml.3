Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3IVEqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 00:46:32 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56212 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3IVEqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 00:46:31 -0400
Date: Sun, 22 Sep 2013 09:46:18 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, dmitry.torokhov@gmail.com,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 3/3] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130922044616.GB2989@gmail.com>
References: <1379571876-12420-1-git-send-email-zubair.lutfullah@gmail.com>
 <1379571876-12420-4-git-send-email-zubair.lutfullah@gmail.com>
 <523DE550.4070107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523DE550.4070107@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 07:28:32PM +0100, Jonathan Cameron wrote:
> On 09/19/13 07:24, Zubair Lutfullah wrote:
> > Previously the driver had only one-shot reading functionality.
> > This patch adds continuous sampling support to the driver.
...
> I've added a SELECT IIO_KFIFO_BUF after the autobuilders picked
> up that was missing.
> 
Thank-you.

> One other thing I'd missed until I was reviewing the updated patch.
> Do you still need the trigger headers?  I can't immediately see why.
> If not, could you post a follow up patch to drop them?
> 

Sure.

Zubair

> Thanks,
> 
> Jonathan
> > ---
> >  drivers/iio/adc/ti_am335x_adc.c      |  213 +++++++++++++++++++++++++++++++++-
> >  include/linux/mfd/ti_am335x_tscadc.h |    9 ++
