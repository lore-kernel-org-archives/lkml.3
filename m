Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaFWQSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:18:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbaFWQSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:18:32 -0400
Date: Mon, 23 Jun 2014 12:18:21 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Tushar Behera <trblinux@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tushar Behera <tushar.b@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: misc: usb3503: Update error code in print message
Message-ID: <20140623161821.GB20421@kroah.com>
References: <1403003330-17553-1-git-send-email-tushar.b@samsung.com>
 <53A0256A.2000904@samsung.com>
 <53A7C67F.3080409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A7C67F.3080409@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 11:47:35AM +0530, Tushar Behera wrote:
> On 06/17/2014 04:54 PM, Marek Szyprowski wrote:
> > Hello,
> > 
> > On 2014-06-17 13:08, Tushar Behera wrote:
> >> 'err' is uninitialized, rather print the error code directly.
> >>
> >> This also fixes following warning.
> >> drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
> >> drivers/usb/misc/usb3503.c:195:11: warning: ‘err’ may be used
> >> uninitialized
> >> in this function [-Wmaybe-uninitialized]
> >>      dev_err(dev, "unable to request refclk (%d)\n", err);
> >>
> >> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
> > 
> > Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > 
> 
> Greg,
> 
> Would you please pick up this patch?

Give me a chance, it's in my todo queue...

