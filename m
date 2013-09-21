Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3IUXPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 19:15:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3IUXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 19:15:08 -0400
Date: Sat, 21 Sep 2013 16:15:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: maxtram95@gmail.com, yamanetoshi@gmail.com, viro@zeniv.linux.org.uk,
        wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 15/19] staging: Change variable type to bool
Message-ID: <20130921231548.GA2769@kroah.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
 <1379802471-30252-15-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379802471-30252-15-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 12:27:47AM +0200, Peter Senna Tschudin wrote:
> The variable ownbit_flag is only assigned the values true and false.
> Change its type to bool.
> 
> The simplified semantic patch that find this problem is as
> follows (http://coccinelle.lip6.fr/):
> 
> @exists@
> type T;
> identifier b;
> @@
> - T
> + bool
>   b = ...;
>   ... when any
>   b = \(true\|false\)
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  drivers/staging/rtl8187se/r8180_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

You sent me 3 patches with the exact same subject: line, which doesn't
bode well for the changelog.  You should update your script to put the
driver name in the subject: to make it more unique and easier to
identify in the future.  I'll fix these 3 up for now.

thanks,

greg k-h
