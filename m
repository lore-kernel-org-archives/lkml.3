Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbaKUIeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:34:37 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:60795 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaKUIee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:34:34 -0500
Message-ID: <546EF913.8030207@gmail.com>
Date: Fri, 21 Nov 2014 09:34:27 +0100
From: Harald Hoyer <harald.hoyer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: kdbus: add header file
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-3-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1416546149-24799-3-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.11.2014 06:02, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@zonque.org>
> …

> +
> +/**
> + * enum kdbus_make_flags - Flags for KDBUS_CMD_{BUS,EP,NS}_MAKE
> + * @KDBUS_MAKE_ACCESS_GROUP:	Make the device node group-accessible
> + * @KDBUS_MAKE_ACCESS_WORLD:	Make the device node world-accessible
> + */
> +enum kdbus_make_flags {
> +	KDBUS_MAKE_ACCESS_GROUP		= 1ULL <<  0,
> +	KDBUS_MAKE_ACCESS_WORLD		= 1ULL <<  1,
> +};
> +

"device node"

…

> +/**
> + * Ioctl API
> + * KDBUS_CMD_BUS_MAKE:		After opening the "control" device node, this
> + *				command creates a new bus with the specified
> + *				name. The bus is immediately shut down and
> + *				cleaned up when the opened "control" device node
> + *				is closed.

"device node"

> + * KDBUS_CMD_ENDPOINT_MAKE:	Creates a new named special endpoint to talk to
> + *				the bus. Such endpoints usually carry a more
> + *				restrictive policy and grant restricted access
> + *				to specific applications.
> + * KDBUS_CMD_HELLO:		By opening the bus device node a connection is
> + *				created. After a HELLO the opened connection
> + *				becomes an active peer on the bus.

"device node"
