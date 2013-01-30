Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3A3IGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:06:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:44222 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab3A3IGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:06:42 -0500
Date: Tue, 29 Jan 2013 23:24:33 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Jake Champlin <jake.champlin.27@gmail.com>
Cc: devendra.aaru@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH] Staging: csr: csr_msgconv: Fixed Multiple Coding Style
 Issues
Message-ID: <20130130042433.GA31597@kroah.com>
References: <20130126220626.GA26467@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130126220626.GA26467@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 05:06:31PM -0500, Jake Champlin wrote:
> Fixed multiple coding style issues
> 
> Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
> ---
>  drivers/staging/csr/csr_msgconv.c | 392 ++++++++++++++++----------------------
>  1 file changed, 169 insertions(+), 223 deletions(-)

Please break this up into the different types of coding style changes
you made, and decribe what you did, in a series of different patches.

thanks,

greg k-h
