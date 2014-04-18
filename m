Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaDRXXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 19:23:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaDRXXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 19:23:07 -0400
Date: Fri, 18 Apr 2014 16:23:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bojan Prtvar <prtvar.b@gmail.com>
Cc: nsankar@broadcom.com, jarod@wilsonet.com, davilla@4pi.com,
        abraham.manu@gmail.com, amarjargal16@gmail.com,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: crystalhd: Mark local functions as static
Message-ID: <20140418232315.GA23165@kroah.com>
References: <1397843871-10850-1-git-send-email-prtvar.b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397843871-10850-1-git-send-email-prtvar.b@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 07:57:51PM +0200, Bojan Prtvar wrote:
> This fixes the following sparse warnings:
> drivers/staging/crystalhd/crystalhd_lnx.c:631:5: warning: symbol 'chd_dec_pci_suspend' was not declared. Should it be static?
> drivers/staging/crystalhd/crystalhd_lnx.c:665:5: warning: symbol 'chd_dec_pci_resume' was not declared. Should it be static?
> drivers/staging/crystalhd/crystalhd_lnx.c:78:29: warning: symbol 'chd_dec_alloc_iodata' was not declared. Should it be static?
> drivers/staging/crystalhd/crystalhd_lnx.c:99:6: warning: symbol 'chd_dec_free_iodata' was not declared. Should it be static?
> 
> Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
> ---
>  drivers/staging/crystalhd/crystalhd_lnx.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

This patch doesn't apply to my tree, can you redo it and resend?

thanks,

greg k-h
