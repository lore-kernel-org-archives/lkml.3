Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbaJWLWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:22:38 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:60312 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbaJWLWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:22:32 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 23 Oct 2014 13:19:27 +0200
From: Johan Hovold <johan@kernel.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, russ.dill@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: serial: Perform verification for FTDI FT232R devices
Message-ID: <20141023111927.GD6641@localhost>
References: <1414054344-3688-1-git-send-email-Russ.Dill@gmail.com>
 <20141023094053.GA30334@kroah.com>
 <20141023121815.1d8ef21d@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023121815.1d8ef21d@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 12:18:15PM +0100, One Thousand Gnomes wrote:
> > >  drivers/usb/serial/ftdi_sio.c | 111 +++++++++++++++++++++++++++++++++++++++++-
> > >  drivers/usb/serial/ftdi_sio.h |  41 ++++++++++++++++
> > >  2 files changed, 151 insertions(+), 1 deletion(-)
> > 
> > Funny patch, you should have saved it for April 1, otherwise people
> > might have actually taken this seriously :)
> > 
> > Patches as performance art, now I've seen everything...
> 
> Chuckle. Sillyness aside a pure detection version of that patch might be
> useful so it can warn users "Running Windows may damage your adapter" 8)
> 
> Is the 0x0000, 0x0401 they end up with consistent - can we add that to the
> default table so end users can at least make use of devices that have
> been attacked by malware ?

Way ahead of you. ;)

	http://marc.info/?l=linux-usb&m=141405129201389&w=2

Johan
