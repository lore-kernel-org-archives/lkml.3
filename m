Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab3KYU3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:29:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3KYU3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:29:01 -0500
Date: Mon, 25 Nov 2013 12:28:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: devel@driverdev.osuosl.org, peter.p.waskiewicz.jr@intel.com,
        linux-kernel@vger.kernel.org, rashika.kheria@gmail.com,
        cruzjbishop@gmail.com
Subject: Re: [PATCH] staging: slicoss: fix possible missing iounmap
Message-ID: <20131125202859.GA29969@kroah.com>
References: <1384554607-2219-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384554607-2219-1-git-send-email-laurent.navet@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:30:07PM +0100, Laurent Navet wrote:
> if slic_card_locate failed, memmapped_ioaddr is not unmapped.
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/staging/slicoss/slicoss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This patch causes a build warning to be added to the system, implying
that you didn't even test-build this patch :(

Sorry, I can't take this as-is for this obvious reason.

Please fix this up and resend.

thanks,

greg k-h
