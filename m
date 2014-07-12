Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaGLAyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:54:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaGLAyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:54:11 -0400
Date: Fri, 11 Jul 2014 17:58:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH] drivers/base: redundant return value settings in
 try_to_bring_up_master()
Message-ID: <20140712005840.GA10558@kroah.com>
References: <1402993531-25244-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402993531-25244-1-git-send-email-Ying.Liu@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 04:25:31PM +0800, Liu Ying wrote:
> Remove redundant return value settings 'ret = 0;' in the function
> try_to_bring_up_master(), since it has already been set to zero.
> 
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
>  drivers/base/component.c |    2 --
>  1 file changed, 2 deletions(-)

This patch no longer applies to my tree, are you sure it's still needed?

If so, please refresh and resend.

thanks,

greg k-h
