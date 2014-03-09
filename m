Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaCIDBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 22:01:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaCIDBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 22:01:10 -0500
Date: Sat, 8 Mar 2014 19:01:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Nick Davies <git@nicolasdavies.com.au>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: comedidev.h Fixed whitespace coding
 style warnings
Message-ID: <20140309030146.GA11060@kroah.com>
References: <1394325951-10406-1-git-send-email-git@nicolasdavies.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394325951-10406-1-git-send-email-git@nicolasdavies.com.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 11:45:51AM +1100, Nick Davies wrote:
> Fixed coding style warnings in comedidev.h which had an extra space
> after the function pointer name.
> 
> Signed-off-by: Nick Davies <git@nicolasdavies.com.au>
> ---
>  drivers/staging/comedi/comedidev.h | 48 +++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 24 deletions(-)

This has already been cleaned up in my tree, be sure to always work off
of the linux-next tree when doing staging tree cleanups to avoid
duplicate work.

thanks

greg k-h
