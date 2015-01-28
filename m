Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbbA1Um0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:42:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934077AbbA1UmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:42:20 -0500
Date: Wed, 28 Jan 2015 11:23:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] fix space required after that ','
Message-ID: <20150128192316.GA22866@kroah.com>
References: <cover.1422267260.git.maryammohamed61@gmail.com>
 <aa2201187c1e773b097042ff99d88b1bd6240469.1422267260.git.maryammohamed61@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa2201187c1e773b097042ff99d88b1bd6240469.1422267260.git.maryammohamed61@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 12:24:33PM +0200, Mariam Mohamed Fawzy wrote:
> This patch fixes the following in checkpatch.pl error:
> space required after that ','
> 
> Signed-off-by: Mariam Mohamed Fawzy <maryammohamed61@gmail.com>
> ---
>  drivers/staging/fbtft/fb_bd663474.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please put in the subject what portion of the kernel you are changing,
like you did in the 0/3 email.

Can you redo these and resend?

thanks,

greg k-h
