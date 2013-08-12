Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3HLWNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:13:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3HLWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:13:22 -0400
Date: Mon, 12 Aug 2013 15:13:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: Linux-Devel <devel@driverdev.osuosl.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Review [2/2] Staging: BCM: Removed more whitespace/Errors
Message-ID: <20130812221321.GC18287@kroah.com>
References: <5203D6E4.9080201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5203D6E4.9080201@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 06:35:32PM +0100, Paul McQuade wrote:
> From 9f6231ce16996e35545e20ce1d91abc058f2a6fb Mon Sep 17 00:00:00 2001
> From: Paul McQuade <paulmcquad@gmail.com>
> Date: Thu, 8 Aug 2013 17:49:22 +0100
> Subject: [PATCH 2/2] Staging: BCM: Removed more whitespace/Errors

Why is this duplicated here?

Just use 'git send-email' to send patches out, that way this isn't a
problem, and also:

>  drivers/staging/bcm/InterfaceMacros.h |    6 +-
>  drivers/staging/bcm/InterfaceMisc.h   |   14 +--
>  drivers/staging/bcm/InterfaceRx.c     |  166
> ++++++++++++++-------------------

Your patch is line-wrapped, making it impossible to apply :(

The whitespace is also all broken.

Take a look at the kernel file, Documentation/email_clients.txt for how
to fix this up properly.

thanks,

greg k-h
