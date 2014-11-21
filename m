Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbaKUI3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:29:19 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35844 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaKUI3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:29:18 -0500
Message-ID: <546EF7DA.20008@gmail.com>
Date: Fri, 21 Nov 2014 09:29:14 +0100
From: Harald Hoyer <harald.hoyer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: kdbus: add documentation
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org> <1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.11.2014 06:02, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@zonque.org>
> …

> +5.4 Creating buses and endpoints
> +--------------------------------
> +
> +KDBUS_CMD_BUS_MAKE, and KDBUS_CMD_ENDPOINT_MAKE take a
> +struct kdbus_cmd_make argument.
> +
> +struct kdbus_cmd_make {
> +  __u64 size;
> +    The overall size of the struct, including its items.
> +
> +  __u64 flags;
> +    The flags for creation.
> +
> +    KDBUS_MAKE_ACCESS_GROUP
> +      Make the device file group-accessible

device?

> +
> +    KDBUS_MAKE_ACCESS_WORLD
> +      Make the device file world-accessible

device?

> +
> +  __u64 kernel_flags;
> +    Valid flags for this command, returned by the kernel upon each call.
> +
> +  struct kdbus_item items[0];
> +    A list of items, only used for creating custom endpoints. Has specific
> +    meanings for KDBUS_CMD_BUS_MAKE and KDBUS_CMD_ENDPOINT_MAKE (see above).
> +};
> …
