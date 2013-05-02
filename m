Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827Ab3EBRe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:34:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51375 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757049Ab3EBRez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:34:55 -0400
Date: Thu, 2 May 2013 13:34:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH, RFC 15/22] USB: EHCI: remove bogus #error
In-Reply-To: <1367507786-505303-16-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1305021333020.1436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Arnd Bergmann wrote:

> The EHCI host controller driver can be built standalone now,
> without enabling any of the available bus glue drivers, so
> there is not really a reason to error out here:

On the other hand, there's no reason to build the driver without any 
bus glue.  It wouldn't do anything.

> drivers/usb/host/ehci-hcd.c:1303:2: error:
>  #error "missing bus glue for ehci-hcd"  #error "missing bus glue for ehci-hcd"
> 
> The alternative would be to change the Kconfig code to build
> the ehci-hcd module only if any of the symbols below are
> in fact enabled.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

