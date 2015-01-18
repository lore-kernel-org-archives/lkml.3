Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbbARASm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:18:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbARASk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:18:40 -0500
Date: Sat, 17 Jan 2015 16:11:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sven Dziadek <sven.dziadek@gmx.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlan-ng: hfa384x_usb: Fix else is not useful
 warning
Message-ID: <20150118001124.GA29888@kroah.com>
References: <1420725677-14766-1-git-send-email-sven.dziadek@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420725677-14766-1-git-send-email-sven.dziadek@gmx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:01:17PM +0100, Sven Dziadek wrote:
> This fixes the following checkpatch.pl warning:
> WARNING: else is not generally useful after a break or return
> 
> Signed-off-by: Sven Dziadek <sven.dziadek@gmx.de>
> ---
>  drivers/staging/wlan-ng/hfa384x_usb.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Someone else sent this same change before you did, sorry.

greg k-h
