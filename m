Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3H0RjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:39:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3H0RjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:39:18 -0400
Date: Tue, 27 Aug 2013 10:41:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: jbaron@akamai.com
Cc: joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic debug: line queries failing due to uninitialized
 local variable
Message-ID: <20130827174136.GG21564@kroah.com>
References: <20130827165003.79F28FE066@prod-mail-relay02.akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827165003.79F28FE066@prod-mail-relay02.akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 04:50:03PM +0000, jbaron@akamai.com wrote:
> Settings of the form, 'line x module y +p', can fail arbitrarily due to an
> uninitialized local variable. With this patch results are consistent, as
> expected.
> 
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> ---
>  lib/dynamic_debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

How far back should this patch go for older kernels?  Is this a bug that
people are hitting today and causing problems, or is it only a 3.11-rc
issue?

thanks,

greg k-h
