Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaJJJXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:23:06 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:43772 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaJJJXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:23:03 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 10 Oct 2014 11:20:14 +0200
From: Johan Hovold <johan@kernel.org>
To: Frans Klaver <frans.klaver@xsens.com>
Cc: Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: serial: ftdi_sio: add Awinda Station and Dongle
 products
Message-ID: <20141010092014.GC12494@localhost>
References: <1412930694-28769-1-git-send-email-frans.klaver@xsens.com>
 <20141010090117.GA12494@localhost>
 <20141010091209.GC3588@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010091209.GC3588@ci00147.xsens-tech.local>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:12:09AM +0200, Frans Klaver wrote:
> On Fri, Oct 10, 2014 at 11:01:17AM +0200, Johan Hovold wrote:
> > On Fri, Oct 10, 2014 at 10:44:54AM +0200, Frans Klaver wrote:

> > > diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
> > > index 5937b2d..be3fffe 100644
> > > --- a/drivers/usb/serial/ftdi_sio_ids.h
> > > +++ b/drivers/usb/serial/ftdi_sio_ids.h
> > > @@ -145,6 +145,8 @@
> > >  #define XSENS_VID		0x2639
> > >  #define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
> > >  #define XSENS_MTW_PID		0x0200	/* Xsens MTw */
> > > +#define XSENS_AWINDA_STATION_PID 0x0101
> > > +#define XSENS_AWINDA_DONGLE_PID 0x0102
> > 
> > And sorted by PID here (even though the two current entries are not, you
> > could reorder them as well).
> > 
> > I noticed that the below PIDs use the FTDI VID. Perhaps a comment or at
> > least a separating empty line would be appropriate.
> > 
> > >  #define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
> > >  #define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
> > >  #define XSENS_CONVERTER_2_PID	0xD38A
> 
> I'll move the new entries up. How about I throw in a separate patch that
> cleans up stuff around the PID definitions? There's some alignment off
> as well. That doesn't need to go into stable, I think.

As long as you keep the clean up minimal (e.g. the reorder the two
entries above and add a comment or new line, skip the alignment bit) it
can all go in one patch along with the new PIDs.

That way there'll be no conflicts when future PID-patches get backported
to stable.

Thanks,
Johan
