Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3KLHci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:32:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3KLHc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:32:27 -0500
Date: Mon, 11 Nov 2013 16:20:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: micky_ching@realsil.com.cn
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH] staging: rts5208: add support for rts5208 and rts5288
Message-ID: <20131112002050.GA1083@kroah.com>
References: <1383901243-8748-1-git-send-email-micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383901243-8748-1-git-send-email-micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 05:00:43PM +0800, micky_ching@realsil.com.cn wrote:
> --- /dev/null
> +++ b/drivers/staging/rts5208/TODO
> @@ -0,0 +1,5 @@
> +TODO:
> +- use kernel coding style
> +- checkpatch.pl fixes
> +- We will use the stack in drivers/mmc to implement
> +  rts5208/5288 in the future

In the TODO file, I need a name and email address of the person who is
going to be responsible for doing the things in the TODO file to get it
out of the staging tree.

Can you please resend this patch with this change?

thanks,

greg k-h
