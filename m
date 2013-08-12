Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3HLSnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:43:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3HLSna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:43:30 -0400
Date: Mon, 12 Aug 2013 11:43:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tilegx: Add tty serial support for TILE-Gx on-chip UART
Message-ID: <20130812184329.GB19875@kroah.com>
References: <201308121836.r7CIa3Kj004272@farm-0021.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308121836.r7CIa3Kj004272@farm-0021.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 02:11:44PM -0400, Chris Metcalf wrote:
> +/*
> + * Enable modem status interrupts.
> + */
> +static void tilegx_enable_ms(struct uart_port *port)
> +{
> +	/* N/A */
> +}
> +
> +/*
> + * Control the transmission of a break signal.
> + */
> +static void tilegx_break_ctl(struct uart_port *port, int break_state)
> +{
> +	/* N/A */
> +}

For most of these "empty" callbacks, you shouldn't have to declare them
at all, and all should work just fine.

Other than that minor nit, at first glance this looks fine to me.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
