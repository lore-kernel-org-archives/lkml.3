Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131AbaEWHkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:40:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaEWHkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:40:52 -0400
Date: Fri, 23 May 2014 16:35:58 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jan Moskyto Matejka <mq@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: removing never #def'd BP_PROC_SUPPORT
Message-ID: <20140523073558.GA8132@kroah.com>
References: <1396868457-7216-1-git-send-email-mq@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396868457-7216-1-git-send-email-mq@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 01:00:57PM +0200, Jan Moskyto Matejka wrote:
> BP_PROC_SUPPORT was never defined so removing all the #ifdef'd code
> including the bp_proc_create() function.
> 
> Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
> ---
>  drivers/staging/silicom/bpctl_mod.c | 39 -------------------------------------
>  1 file changed, 39 deletions(-)

Someone sent this same patch before you did, sorry :(

greg k-h
