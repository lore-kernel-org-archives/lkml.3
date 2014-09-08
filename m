Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaIHWcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:32:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaIHWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:32:50 -0400
Date: Mon, 8 Sep 2014 15:32:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, jslaby@suse.cz,
        grant.likely@linaro.org, alan@linux.intel.com, varkabhadram@gmail.com,
        tklauser@distanz.ch, heiko@sntech.de, yingjoe.chen@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v4 1/2] tty: serial: 8250: Add Mediatek UART driver
Message-ID: <20140908223249.GA26114@kroah.com>
References: <1407852737-17265-1-git-send-email-matthias.bgg@gmail.com>
 <1407852737-17265-2-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407852737-17265-2-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 04:12:16PM +0200, Matthias Brugger wrote:
> The device has a highspeed register which influences the calcualtion of the
> divisor. The chip lacks support for some baudrates. When requested, we set the
> divisor to the next smaller baudrate and adjust the c_cflag accordingly.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  drivers/tty/serial/8250/8250_mtk.c |  294 ++++++++++++++++++++++++++++++++++++
>  drivers/tty/serial/8250/Kconfig    |    7 +
>  drivers/tty/serial/8250/Makefile   |    1 +
>  3 files changed, 302 insertions(+)
>  create mode 100644 drivers/tty/serial/8250/8250_mtk.c

This doesn't apply to my tree, care to refresh it against linux-next and
resend?

thanks,

greg k-h
