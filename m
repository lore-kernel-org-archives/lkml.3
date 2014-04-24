Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaDXXSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:18:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaDXXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:18:07 -0400
Date: Thu, 24 Apr 2014 16:21:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: jon@ringle.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        shc_work@mail.ru, Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH v6 1/2] serial: sc16is7xx
Message-ID: <20140424232100.GA32660@kroah.com>
References: <1397612393-31855-1-git-send-email-jon@ringle.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397612393-31855-1-git-send-email-jon@ringle.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 09:39:52PM -0400, jon@ringle.org wrote:
> From: Jon Ringle <jringle@gridpoint.com>
> 
> The SC16IS7xx is a slave I2C-bus/SPI interface to a single-channel
> high performance UART. The SC16IS7xx's internal register set is
> backward-compatible with the widely used and widely popular 16C450.
> 
> The SC16IS7xx also provides additional advanced features such as
> auto hardware and software flow control, automatic RS-485 support, and
> software reset.
> 
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  drivers/tty/serial/Kconfig       |    9 +
>  drivers/tty/serial/Makefile      |    1 +
>  drivers/tty/serial/sc16is7xx.c   | 1279 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/serial_core.h |    3 +
>  4 files changed, 1292 insertions(+)
>  create mode 100644 drivers/tty/serial/sc16is7xx.c

Due to other patches, this doesn't apply to my tree anymore.  Can you
refresh it against the tty-next branch on the tty.git tree from
git.kernel.org?

thanks,

greg k-h
