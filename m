Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3H1SdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:33:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3H1SdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:33:13 -0400
Date: Wed, 28 Aug 2013 11:35:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "shawn.guo@linaro.org Guo" <shawn.guo@linaro.org>,
        "s.hauer@pengutronix.de Hauer" <s.hauer@pengutronix.de>
Subject: Re: merging device tree binding dirs for serial bindings
Message-ID: <20130828183534.GC14627@kroah.com>
References: <F93329E6-1426-4197-871D-211F34455DDE@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F93329E6-1426-4197-871D-211F34455DDE@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 01:02:14PM -0500, Kumar Gala wrote:
> We appear to have:
> 
> Documentation/devicetree/bindings/serial/
> 
> and
> 
> Documentation/devicetree/bindings/tty/serial/
> 
> Which one do we want to keep, I'd pick the first, but I don't care too much.

I don't care, I never created either one, and don't do any devicetree
stuff, so it's up to the devicetree maintainers to pick one.

thanks,

greg k-h
