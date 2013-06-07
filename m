Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3FGRZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:25:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3FGRZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:25:36 -0400
Date: Fri, 7 Jun 2013 10:25:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tobias Winter <tobias@linuxdingsda.de>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Increase the number of USB to serial devices we
 can support at once
Message-ID: <20130607172535.GB29371@kroah.com>
References: <20130606173103.GA1812@kroah.com>
 <51B176FB.9070509@linuxdingsda.de>
 <51B1AE2F.3040405@linuxdingsda.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51B1AE2F.3040405@linuxdingsda.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:55:59AM +0200, Tobias Winter wrote:
> On 06/07/2013 08:00 AM, Tobias Winter wrote:
> >   CC      drivers/usb/serial/console.o
> > drivers/usb/serial/console.c: In function ‘usb_console_setup’:
> > drivers/usb/serial/console.c:111:2: error: implicit declaration of
> > function ‘usb_serial_get_by_index’ [-Werror=implicit-function-declaration]
> > drivers/usb/serial/console.c:111:9: warning: assignment makes pointer
> > from integer without a cast [enabled by default]
> > drivers/usb/serial/console.c:122:40: error: ‘struct usb_serial’ has no
> > member named ‘minor’
> > cc1: some warnings being treated as errors
> > make[4]: *** [drivers/usb/serial/console.o] Error 1
> > make[3]: *** [drivers/usb/serial] Error 2
> > make[2]: *** [drivers/usb] Error 2
> > make[1]: *** [drivers] Error 2
> > make[1]: Leaving directory `/root/usb.git'
> > make: *** [debian/stamp/build/kernel] Error 2
> 
> Despite that broken driver, I just gave it a try and the patchset works
> as expected.

Thanks for testing, I forgot to update the console code, as no one sane
every runs it :)

I'll go fix that up now...

thanks,

greg k-h
