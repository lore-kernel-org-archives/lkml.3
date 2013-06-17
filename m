Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3FQXqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:46:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3FQXqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:46:37 -0400
Date: Mon, 17 Jun 2013 16:46:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: dzu@denx.de, hjk@hansjkoch.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] fix UIO with device tree but no assigned interrupt
Message-ID: <20130617234635.GA4521@kroah.com>
References: <20130617134957.GA15602@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617134957.GA15602@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 03:49:57PM +0200, Pavel Machek wrote:
> If device is initialized from device tree, but has no interrupt assigned,
> uio will still try to request and interrupt old way, fails, and fails registration.
>    
> This is wrong; don't try initializing irq using platform data if device tree is
> available.

Doesn't apply cleanly to my tree, can you redo it against the
char-misc-next branch of my git tree?

thanks,

greg k-h
