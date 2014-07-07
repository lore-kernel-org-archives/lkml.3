Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaGGIyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:54:23 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:47492 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaGGIyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:54:19 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 7 Jul 2014 10:53:43 +0200
From: Johan Hovold <johan@kernel.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oliver Neukum <oliver@neukum.org>, kernel-janitors@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/11 V2] USB: kl5kusb105: Remove klsi_105_tiocmset
 function
Message-ID: <20140707085343.GE29098@localhost>
References: <1401552180-9445-1-git-send-email-peter.senna@gmail.com>
 <20140601093117.GC14935@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140601093117.GC14935@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 11:31:17AM +0200, Johan Hovold wrote:
> On Sat, May 31, 2014 at 01:03:00PM -0300, Peter Senna Tschudin wrote:
> > This patch remove the function klsi_105_tiocmset which was only
> > returning -EINVAL. It also removes the function prototype and
> > the .tiocmset entry in the struct usb_serial_driver.
> > 
> > Verified by compilation only.
> > 
> > Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

It seems this one was never picked up, but I'm applying it to my tree
now.

Thanks again, Peter.

Johan
