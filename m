Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbaFKOHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:07:31 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:65134 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaFKOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:07:29 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 11 Jun 2014 16:06:48 +0200
From: Johan Hovold <johan@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Janne Kanniainen <janne.kanniainen@gmail.com>, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        johan@kernel.org
Subject: Re: [PATCH v3] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140611140648.GH10256@localhost>
References: <CAEEjW06BnCiLyDDL82fjhFtwg5LyaGzKP+swzLFNKKwmZcvViQ@mail.gmail.com>
 <1402435299-16410-1-git-send-email-janne.kanniainen@gmail.com>
 <alpine.LNX.2.00.1406111325000.1321@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406111325000.1321@pobox.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 01:25:49PM +0200, Jiri Kosina wrote:
> On Wed, 11 Jun 2014, Janne Kanniainen wrote:
> 
> > This driver adds support for USB controlled led panels that exists in MSI GT683R laptop
> > 
> > Changes in v2:
> > 	- sorted headers to alphabetic order
> > 	- using devm_kzalloc
> > 	- using BIT(n)
> > 	- using usb_control_msg instead of usb_submit_urb
> > 	- removing unneeded code
> > 
> > Changes in v3:
> > 	- implemented as HID device
> > 	- some cleanups and bug fixes
> > 
> > Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
> 
> Thanks for the driver. Johan, as you did a very good job reviewing this 
> before I managed to get to it, I'd be glad to put your Reviewed-by: to the 
> commit before commiting it, if you are going to provide it.

I had a few more comments to v3, but I'll make sure to reply with a
Reviewed-by-tag before you apply.

Thanks,
Johan
