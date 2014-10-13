Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaJMD0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 23:26:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaJMD0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 23:26:47 -0400
Date: Mon, 13 Oct 2014 05:25:44 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] staging: dgap: re-arrange functions for removing forward
 declarations.
Message-ID: <20141013032544.GA26646@kroah.com>
References: <20141013023425.GA15452@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013023425.GA15452@devel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 11:34:25AM +0900, Daeseok Youn wrote:
> Re-arrange the functions for removing forward declarations.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> This patch has too many changes for re-arranging the functions.
> So I wonder that I should break this up into smaller patches.

Are the .o files identical before and after this patch?  If so, it's
fine.

thanks,

greg k-h
