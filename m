Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaE0S71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:59:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaE0S7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:59:11 -0400
Date: Tue, 27 May 2014 12:02:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navin.patidar@gmail.com>
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] staging: rtl8188eu:Remove unused macro
 _init_queue()
Message-ID: <20140527190244.GA22680@kroah.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
 <1401204955-4093-3-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401204955-4093-3-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 09:05:43PM +0530, navin patidar wrote:
> Signed-off-by: navin patidar <navin.patidar@gmail.com>
> ---
>  drivers/staging/rtl8712/osdep_service.h |    6 ------
>  1 file changed, 6 deletions(-)

This is the rtl8712 driver, not the rtl8188eu driver.

And this patch causes a build error.

Please ALWAYS test your patches before sending them out :(

thanks,

greg k-h
