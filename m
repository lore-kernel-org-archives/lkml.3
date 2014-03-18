Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbaCRUjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:39:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbaCRUjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:39:05 -0400
Date: Tue, 18 Mar 2014 13:41:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Silvio F <silvio.fricke@gmail.com>
Cc: linux-kernel@vger.kernel.org, daeseok.youn@gmail.com, silvio@port1024.net
Subject: Re: [PATCH] staging: unisys: kmalloc/memset to kzalloc conversation
Message-ID: <20140318204107.GA26473@kroah.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
 <1395173271-13190-1-git-send-email-silvio.fricke@gmail.com>
 <1395173271-13190-2-git-send-email-silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395173271-13190-2-git-send-email-silvio.fricke@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 09:07:51PM +0100, Silvio F wrote:
> This patch solves the Coccinelle warning: "kzalloc should be used
> instead of kmalloc/memset"
> 
> This patch is a fixup for
> 
> 	linux-next: 97a84f1203786985856a0d4b49b1d7cc387238ce
> 	"Staging: unisys: Replace kmalloc/memset with kzalloc"
> 
> Signed-off-by: Silvio F <silvio.fricke@gmail.com>
> ---
>  drivers/staging/unisys/include/uisutils.h           | 5 +----
>  drivers/staging/unisys/virthba/virthba.c            | 3 +--
>  drivers/staging/unisys/virtpci/virtpci.c            | 3 +--
>  drivers/staging/unisys/visorutil/memregion_direct.c | 5 ++---
>  drivers/staging/unisys/visorutil/periodic_work.c    | 5 ++---
>  5 files changed, 7 insertions(+), 14 deletions(-)

If you don't cc: the maintainers of the code, they will never see this
and it can't be applied :(

Care to resend it properly?

thanks,

greg k-h
