Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3FAWQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 18:16:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49194 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752202Ab3FAWQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 18:16:01 -0400
Message-ID: <1370124960.2098.9.camel@joe-AO722>
Subject: Re: [PATCH] usb: musb: use the new %pa format specifier for
 dma_addr_t
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Emil Goode <emilgoode@gmail.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>, balbi@ti.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sat, 01 Jun 2013 15:16:00 -0700
In-Reply-To: <51AA6E1F.7080003@infradead.org>
References: <1370109747-18821-1-git-send-email-emilgoode@gmail.com>
	 <1370111350.2098.1.camel@joe-AO722> <20130601190926.GA5541@debian>
	 <1370118685.2098.7.camel@joe-AO722> <51AA6E1F.7080003@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 14:56 -0700, Randy Dunlap wrote:
> It's a bit of a shame that this
> comment was deleted from include/asm-generic/types.h in commit
> 3e50594e8e72932ad4cfcb0b3cbdf58fc3bce416:
> 
> -/*
> - * DMA addresses may be very different from physical addresses
> - * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
> - * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
> - * physical addresses.
> - * This default defines dma_addr_t to have the same size as
> - * phys_addr_t, which is the most common way.
> - * Do not define the dma64_addr_t type, which never really
> - * worked.
> - */

Hey Randy.

You could always put it back.


