Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3EQD4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:56:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34864 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3EQD4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:56:33 -0400
Date: Thu, 16 May 2013 18:21:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: parport: Use kmemdup
Message-ID: <20130517012125.GA16963@kroah.com>
References: <1367168078-22486-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367168078-22486-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 28, 2013 at 07:54:38PM +0300, Alexandru Gheorghiu wrote:
> Used kmemdup instead of kmalloc and memcpy.
> Patch found using coccinelle.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  drivers/parport/parport_gsc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

This patch doesn't apply to my tree, care to redo it and resend it?

thanks,

greg k-h
