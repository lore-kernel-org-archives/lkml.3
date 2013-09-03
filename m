Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab3ICVil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:38:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3ICVik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:38:40 -0400
Date: Tue, 3 Sep 2013 14:38:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fix typo in usb serial simple driver Kconfig
Message-ID: <20130903213839.GA16307@kroah.com>
References: <20130903211838.GC2247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903211838.GC2247@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 05:18:38PM -0400, Dave Jones wrote:
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
> index c454bfa..ddb9c51 100644
> --- a/drivers/usb/serial/Kconfig
> +++ b/drivers/usb/serial/Kconfig
> @@ -60,7 +60,7 @@ config USB_SERIAL_SIMPLE
>  		- Suunto ANT+ USB device.
>  		- Fundamental Software dongle.
>  		- HP4x calculators
> -		- a number of Motoroloa phones
> +		- a number of Motorola phones

Doh, that was stupid, thanks, I'll queue this up after 3.12-rc1 is out.

greg k-h
