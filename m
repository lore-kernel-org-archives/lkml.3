Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3DUI4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 04:56:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35652 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3DUI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 04:56:50 -0400
Date: Sun, 21 Apr 2013 09:53:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2] serial: pl011: Add Device Tree support to request
	DMA channels
Message-ID: <20130421085321.GD14496@n2100.arm.linux.org.uk>
References: <1366272857-14038-1-git-send-email-lee.jones@linaro.org> <201304201233.45501.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304201233.45501.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 12:33:45PM +0200, Arnd Bergmann wrote:
> @@ -315,6 +325,7 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
>  struct dma_uap {
>  	struct list_head node;
>  	struct uart_amba_port *uap;
> +	struct device *dev;

There is really no need for this.  This device is available via uap->port.dev.
