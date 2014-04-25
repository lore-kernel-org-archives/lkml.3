Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaDYWWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:22:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaDYWWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:22:07 -0400
Date: Fri, 25 Apr 2014 15:24:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tair <tair.rzayev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: keucr: smilmain.c: Fix sparse warning
Message-ID: <20140425222459.GA25868@kroah.com>
References: <53555897.10409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53555897.10409@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 08:42:47PM +0300, Tair wrote:
> From: Tair Rzayev <tair.rzayev@gmail.com>
> 
> Fix "Should be static" sparse warning:
> * Add Check_D_MediaFmt() declaration to smil.h;
> * Move Check_D_MediaFmt() implementation up in smilmain.c to keep
>   all the non-static functions at the top of the file;
> * Include "init.h" into "smil.h", remove externs from "smil.h"
>   which are no longer needed;
> * SM_Init[] and SM_Rdwr[] are renamed because otherwise SM_Init[]
>   collides with SM_Init() from "smil.h".

That's a lot of things to do all at once.

In fact, it doesn't apply to my tree anymore because someone else just
did a part of what you did, so this might not be needed anymore.  Can
you please rebase your patch on top of my staging-next branch on the
staging.git tree on git.kernel.org and resend it?

thanks,

greg k-h
