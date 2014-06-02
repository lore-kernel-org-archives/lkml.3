Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaFBQUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:20:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52715 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbaFBQUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:20:13 -0400
X-Sasl-enc: 9THgwb/GGZkV1k0HN6YBLuliPRQrVm2dOVdpwwDjcMCP 1401726010
Date: Mon, 2 Jun 2014 09:23:46 -0700
From: Greg KH <greg@kroah.com>
To: Mike Remski <mremski@mutualink.net>
Cc: Johan Hovold <jhovold@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
Message-ID: <20140602162346.GA26156@kroah.com>
References: <538C8963.4010909@mutualink.net>
 <20140602143347.GA1902@localhost>
 <538C953B.9020304@mutualink.net>
 <20140602154036.GA8662@localhost>
 <538CA1C0.1080205@mutualink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538CA1C0.1080205@mutualink.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 12:09:36PM -0400, Mike Remski wrote:
> On 06/02/2014 11:40 AM, Johan Hovold wrote:
> >[ Please avoid top-posting. ]
> >
> >On Mon, Jun 02, 2014 at 11:16:11AM -0400, Mike Remski wrote:
> >>Thanks Johan, that's why I looked at the cross references for ftdi_sio.c
> >>over on
> >>http://lxr.free-electrons.com/source/drivers/usb/serial/ftdi_sio.c,
> >>latest version it's showing is 3.14.  It appears that the ftdi_sio code
> >>is largely the same as in 2.6.32, particularly in the
> >>ftdi_set_max_packet_size() function.
> >Lots of things have changed since v2.6.32 and not just in the driver
> >itself but in all the infrastructure it relies on.
> >
> >>I'm trying to verify if the "number of endpoints is 0" is a valid
> >>situation.
> >No, that is not normal, but it should not crash the driver if it's a
> >hardware issue. What is the lsusb -v output of your device (make sure
> >the ftdi_sio driver isn't loaded when connecting the device).
> >
> >And what happens if you plug it into a machine running a recent kernel?
> >
> >Thanks,
> >Johan
> Plugging device into a system running Redhat, kernel 3.3.4 crashes the
> system.

3.3.4 is still _many_ years old.  Please try something from 2014 at the
latest...
