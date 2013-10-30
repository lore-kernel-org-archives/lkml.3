Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3J3NWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:22:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3J3NWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:22:33 -0400
Date: Wed, 30 Oct 2013 06:24:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: atmel_pwm: add deferred-probing support
Message-ID: <20131030132432.GB30447@kroah.com>
References: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
 <1382459560-26596-2-git-send-email-jhovold@gmail.com>
 <20131030112551.GB29813@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030112551.GB29813@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:25:51PM +0100, Johan Hovold wrote:
> On Tue, Oct 22, 2013 at 06:32:39PM +0200, Johan Hovold wrote:
> > Two drivers (atmel-pwm-bl and leds-atmel-pwm) currently depend on the
> > atmel_pwm driver to have bound to any pwm-device before their devices
> > are probed.
> > 
> > Support deferred probing of such devices by making sure to return
> > -EPROBE_DEFER from pwm_channel_alloc when no pwm-device has yet been
> > bound.
> > 
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> 
> This patch, 5c6d6fd1 ("misc: atmel_pwm: add deferred-probing support"),
> and 9d3fde86 ("backlight: atmel-pwm-bl: fix deferred probe from __init")
> in linux-next should probably be considered for inclusion in stable.
> 
> Without them the atmel-pwm-bl driver may always fail to probe depending
> on link order.

Ok, I'll watch this for when it hits Linus's tree, thanks for letting me
know.

greg k-h
