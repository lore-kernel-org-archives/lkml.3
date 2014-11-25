Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaKYR4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:56:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaKYRz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:55:59 -0500
Date: Tue, 25 Nov 2014 09:36:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: icyflame <kannan.siddharth12@gmail.com>
Cc: mail@beyermatthias.de, rickard_strandqvist@spectrumdigital.se,
        ztugcesirin@gmail.com, fanwlexca@gmail.com, rashika.kheria@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        klmckinney1@gmail.com
Subject: Re: [PATCH] staging: bcm: nvm: Fixed spelling errors, that may break
 grep.
Message-ID: <20141125173625.GA3453@kroah.com>
References: <1416936635-5375-1-git-send-email-kannan.siddharth12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416936635-5375-1-git-send-email-kannan.siddharth12@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 11:00:35PM +0530, icyflame wrote:
> Changing the following:
> 
> Adapater -> Adapter
> STATUS_SUCESS -> STATUS_SUCCESS
> 
> Signed-off by: Siddharth Kannan <kannan.siddharth12@gmail.com>
> ---
>  drivers/staging/bcm/nvm.c |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)

Your "From:" line name does not match  your Signed-off-by: line (and you
typoed Signed-off-by:), so I can't take this patch, sorry.

Please fix and resend.

greg k-h
