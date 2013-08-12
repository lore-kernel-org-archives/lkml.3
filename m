Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3HLS4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:56:42 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:59975 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3HLS4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:56:39 -0400
Message-ID: <52092FE5.8030006@tilera.com>
Date: Mon, 12 Aug 2013 14:56:37 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tilegx: Add tty serial support for TILE-Gx on-chip UART
References: <201308121836.r7CIa3Kj004272@farm-0021.internal.tilera.com> <20130812184329.GB19875@kroah.com>
In-Reply-To: <20130812184329.GB19875@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/2013 2:43 PM, Greg Kroah-Hartman wrote:
> On Mon, Aug 12, 2013 at 02:11:44PM -0400, Chris Metcalf wrote:
>> +/*
>> + * Enable modem status interrupts.
>> + */
>> +static void tilegx_enable_ms(struct uart_port *port)
>> +{
>> +	/* N/A */
>> +}
>> +
>> +/*
>> + * Control the transmission of a break signal.
>> + */
>> +static void tilegx_break_ctl(struct uart_port *port, int break_state)
>> +{
>> +	/* N/A */
>> +}
> For most of these "empty" callbacks, you shouldn't have to declare them
> at all, and all should work just fine.

I may be missing something, but it looks like drivers/tty/serial/serial_core.c
calls all of the "empty" callbacks unconditionally, so some definition
is required.

> Other than that minor nit, at first glance this looks fine to me.
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

