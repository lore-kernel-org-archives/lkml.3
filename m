Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432Ab3DHRWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:22:37 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59303 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3DHRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:22:36 -0400
Date: Mon, 8 Apr 2013 10:22:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tyrel Datwyler <turtle.on.the.radio@gmail.com>
Cc: eduardo.falentin@ti.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: omap-thermal: remove trailing whitespace from
 omap-bandgap.c
Message-ID: <20130408172233.GA26206@kroah.com>
References: <1365385640-10443-1-git-send-email-turtle.on.the.radio@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365385640-10443-1-git-send-email-turtle.on.the.radio@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 06:47:20PM -0700, Tyrel Datwyler wrote:
> This patch removes trailing whitespace from a blank line in omap-bandgap.c as
> detected by the checkpatch.pl tool.
> 
> Signed-off-by: Tyrel Datwyler <turtle.on.the.radio@gmail.com>
> ---
>  drivers/staging/omap-thermal/omap-bandgap.c | 2 +-

This file no longer is in my tree, are you sure you made this against
the proper branch?  Please always make staging patches against the
linux-next tree.

thanks,

greg k-h
