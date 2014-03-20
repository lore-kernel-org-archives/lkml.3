Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaCTOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:09:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53961 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbaCTOJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:09:27 -0400
Date: Thu, 20 Mar 2014 14:08:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "jon@ringle.org" <jon@ringle.org>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH] tty: serial: sc16is7xx
Message-ID: <20140320140848.GB23372@e106331-lin.cambridge.arm.com>
References: <1395324177-15311-1-git-send-email-jon@ringle.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395324177-15311-1-git-send-email-jon@ringle.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 02:02:57PM +0000, jon@ringle.org wrote:
> From: Jon Ringle <jringle@gridpoint.com>
> 
> The SC16IS7xx is a slave I2C-bus/SPI interface to a single-channel
> high performance UART. The SC16IS7xx’s internal register set is
> backward-compatible with the widely used and widely popular 16C450.
> 
> The SC16IS7xx also provides additional advanced features such as
> auto hardware and software flow control, automatic RS-485 support, and
> software reset.
> 
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  drivers/tty/serial/Kconfig       |   10 +
>  drivers/tty/serial/Makefile      |    1 +
>  drivers/tty/serial/sc16is7xx.c   | 1258 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/serial_core.h |    3 +
>  4 files changed, 1272 insertions(+)
>  create mode 100644 drivers/tty/serial/sc16is7xx.c

[...]

> +static const struct of_device_id __maybe_unused sc16is7xx_dt_ids[] = {
> +       { .compatible = "nxp,sc16is740",        .data = &sc16is74x_devtype, },
> +       { .compatible = "nxp,sc16is741",        .data = &sc16is74x_devtype, },
> +       { .compatible = "nxp,sc16is750",        .data = &sc16is750_devtype, },
> +       { .compatible = "nxp,sc16is752",        .data = &sc16is752_devtype, },
> +       { .compatible = "nxp,sc16is760",        .data = &sc16is760_devtype, },
> +       { .compatible = "nxp,sc16is762",        .data = &sc16is762_devtype, },
> +       { }
> +};

Please document these strings (even if under a trivial binding
document).

Cheers,
Mark.
