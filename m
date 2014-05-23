Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaEWSjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:39:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaEWSjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:39:15 -0400
Date: Fri, 23 May 2014 20:16:25 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: David Matlack <matlackdavid@gmail.com>
Cc: devel@driverdev.osuosl.org, charrer@alacritech.com,
        linux-kernel@vger.kernel.org, liodot@gmail.com
Subject: Re: [PATCH 2/2] staging: slicoss: handle errors from slic_config_get
Message-ID: <20140523111625.GA4092@kroah.com>
References: <1400819925-19390-1-git-send-email-matlackdavid@gmail.com>
 <1400819925-19390-3-git-send-email-matlackdavid@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400819925-19390-3-git-send-email-matlackdavid@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 09:38:45PM -0700, David Matlack wrote:
> slic_config_get() can fail. Change the return type from void to
> int and handle the error in slic_card_init(). So now, instead of
> silently failing (and then timing out waiting for the config data),
> the driver will fail loudly at request time.
> 
> Signed-off-by: David Matlack <matlackdavid@gmail.com>
> ---
>  drivers/staging/slicoss/slicoss.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)

It looks like I had already applied patch 1/2 here, but not this one,
odd.

Anyway, I've applied this, and should be synced up with you now.  If I
have missed applying anything, please resend.

thanks,

greg k-h
