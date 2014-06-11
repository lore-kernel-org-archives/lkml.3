Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaFKLZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:25:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaFKLZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:25:51 -0400
Date: Wed, 11 Jun 2014 13:25:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
cc: cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v3] leds: USB: HID: Add support for MSI GT683R led
 panels
In-Reply-To: <1402435299-16410-1-git-send-email-janne.kanniainen@gmail.com>
Message-ID: <alpine.LNX.2.00.1406111325000.1321@pobox.suse.cz>
References: <CAEEjW06BnCiLyDDL82fjhFtwg5LyaGzKP+swzLFNKKwmZcvViQ@mail.gmail.com> <1402435299-16410-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Janne Kanniainen wrote:

> This driver adds support for USB controlled led panels that exists in MSI GT683R laptop
> 
> Changes in v2:
> 	- sorted headers to alphabetic order
> 	- using devm_kzalloc
> 	- using BIT(n)
> 	- using usb_control_msg instead of usb_submit_urb
> 	- removing unneeded code
> 
> Changes in v3:
> 	- implemented as HID device
> 	- some cleanups and bug fixes
> 
> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>

Thanks for the driver. Johan, as you did a very good job reviewing this 
before I managed to get to it, I'd be glad to put your Reviewed-by: to the 
commit before commiting it, if you are going to provide it.

Thanks,

-- 
Jiri Kosina
SUSE Labs
