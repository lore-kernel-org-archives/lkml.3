Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3FGJu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:50:56 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49798 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FGJuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:50:54 -0400
Date: Fri, 7 Jun 2013 11:50:45 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] USB: serial: make minor allocation dynamic
Message-ID: <20130607095045.GL2566@localhost>
References: <20130606173103.GA1812@kroah.com>
 <20130606173121.GA1866@kroah.com>
 <20130607094025.GK2566@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607094025.GK2566@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:40:25AM +0200, Johan Hovold wrote:
> On Thu, Jun 06, 2013 at 10:31:21AM -0700, Greg KH wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> [...]
> 
> >  /* Functions needed by other parts of the usbserial core */
> > -extern struct usb_serial *usb_serial_get_by_index(unsigned int minor);
> > +extern struct usb_serial_port *usb_serial_port_get_by_minor(unsigned int minor);
> 
> As Tobias already noted, this breaks the USB console driver. However, it
> looks like the call in that driver is not really needed and that
> therefore usb_serial_port_get_by_minor need not be exported at all.

Forget that last sentence. It is still needed, of course.

Johan
