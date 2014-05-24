Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaEXUFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 16:05:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaEXUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 16:05:01 -0400
Date: Sat, 24 May 2014 13:05:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: introduce function imx_free_mx3_camera
Message-ID: <20140524200500.GB1023@kroah.com>
References: <1400781080-6117-1-git-send-email-emilgoode@gmail.com>
 <20140522181024.GA20155@pengutronix.de>
 <20140524152200.GA4666@lianli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140524152200.GA4666@lianli>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 05:22:00PM +0200, Emil Goode wrote:
> Hello Uwe and Greg,
> 
> > You'd do a better deed if you picked up
> > http://thread.gmane.org/gmane.linux.kernel/1613364/focus=1635995
> 
> Since there is nothing wrong with the last version of the patch in
> the above thread, I feel strange about picking it up and just splitting
> it into two patches. However it would be good to have it applied.
> 
> I think the reason why the author didn't resend is that the object file
> and data structure layout information in the changelog depend on the
> changes to both .name and .dma_mask and by splitting the patch this
> information would not apply to any one of the resulting two patches.
> 
> Perhaps keeping this information in the changelog is a good reason for
> applying the patch as it is?

If you read the thread, I explained why I didn't want to take the patch
as-is.  Please feel free to break it up as asked for and I'll be glad to
consider it then.

thanks,

greg k-h
