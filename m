Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3HVWzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:55:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3HVWzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:55:46 -0400
Date: Thu, 22 Aug 2013 15:55:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, laforge@gnumonks.org
Subject: Re: [PATCH] Omnikey Cardman 4000: pull in ioctl.h in user header
Message-Id: <20130822155545.e263454227265e049f58f6a3@linux-foundation.org>
In-Reply-To: <1376676429-3953-1-git-send-email-vapier@gentoo.org>
References: <1376676429-3953-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Aug 2013 14:07:09 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> This file uses the ioctl helpers (_IOR/_IOW/etc...), so include ioctl.h
> for the definitions.
> 
> ...
>
> --- a/include/uapi/linux/cm4000_cs.h
> +++ b/include/uapi/linux/cm4000_cs.h
> @@ -2,6 +2,7 @@
>  #define _UAPI_CM4000_H_
>  
>  #include <linux/types.h>
> +#include <linux/ioctl.h>
>  
>  #define	MAX_ATR			33

I'm assuming this fixes a build error under unknown circumstances, or
not, or something else?
