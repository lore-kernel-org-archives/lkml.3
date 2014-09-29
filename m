Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaI2GRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 02:17:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaI2GRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 02:17:30 -0400
Date: Sun, 28 Sep 2014 22:02:29 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Mike Roocroft <mike.linux@btinternet.com>
Cc: devel@driverdev.osuosl.org, swetland@google.com,
        sudipm.mukherjee@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: Staging: Android: sw_sync: Fixed a blank line
 after declaration coding style issue on lines 100 and 159
Message-ID: <20140929020229.GA15900@kroah.com>
References: <1411902896-9934-1-git-send-email-mike.linux@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411902896-9934-1-git-send-email-mike.linux@btinternet.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 12:14:56PM +0100, Mike Roocroft wrote:
> Fixed a coding style issue
> 
> Signed-off-by: Mike Roocroft <mike.linux@btinternet.com>
> ---
>  drivers/staging/android/sw_sync.c | 2 ++
>  1 file changed, 2 insertions(+)

This patch was done already by someone else, please always use the
latest version of my tree, or linux-next.

thanks,

greg k-h
