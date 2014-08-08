Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaHHNmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:42:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaHHNmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:42:20 -0400
Date: Fri, 8 Aug 2014 06:41:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Add missing parameter description to
 kerneldoc
Message-ID: <20140808134147.GC4427@kroah.com>
References: <1407490591-15754-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407490591-15754-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 11:36:31AM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The deferred_probe_work_func() takes a single parameter but the
> kerneldoc doesn't describe it.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Note that since the function is locally scoped there isn't all that much
> point in having a kerneldoc comment for it, but since it's already there
> might as well make it correct.

How about just removing the kerneldoc format so this isn't an issue?

thanks,

greg k-h
