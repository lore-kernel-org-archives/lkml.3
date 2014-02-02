Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaBBJba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 04:31:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaBBJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 04:31:26 -0500
Date: Sun, 2 Feb 2014 10:32:52 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ulrich Hahn <uhahn@eanco.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ..another device for the ftdi_sio driver, 2nd infusion
Message-ID: <20140202093252.GA9994@kroah.com>
References: <1391332936.30603.1@biblenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391332936.30603.1@biblenovo>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 10:22:16AM +0100, Ulrich Hahn wrote:
> Thanks, Greg to your bot for the hint,
> 
> gmail seems to screw up tabs for spaces. Good to know, learning by doing..
> Lets give it another try:
>  
> >finally I prepared a patch for the famous ftdi_sio usb serial driver.
> >Adding two Tagsys RFID readers I am using.
> >After having asked Bill Ryder he suggested adressing the
> >linux-usb-devel mailing list. (what?)
> 
> >Sorry for the mess below - I am not doing this frequently - being
> >rather a leecher over the last 20 years:-)
> 
> 
> Signed-off-by: Ulrich Hahn <uhahn@eanco.de>

That's better, but I have to edit the above by hand, which isn't a big
deal, but when you deal with tens of thousands of patches a year,
doesn't scale :(

> 
> diff -uprN linux-source-3.2.0/drivers/usb/serial/ftdi_sio.c linux-source-3.2.0+tagsysRFID/drivers/usb/serial/ftdi_sio.c
> --- linux-source-3.2.0/drivers/usb/serial/ftdi_sio.c	2013-12-03 18:40:26.000000000 +0100
> +++ linux-source-3.2.0+tagsysRFID/drivers/usb/serial/ftdi_sio.c	2014-02-01 16:32:40.146698791 +0100

3.2.0 is over 2 years old, things have moved on a bit since then :)

Can you redo this patch against the 3.13.0 kernel release, to have a
chance for it to be able to be applied?

thanks,

greg k-h
