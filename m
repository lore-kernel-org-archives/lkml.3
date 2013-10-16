Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934913Ab3JPOLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:11:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934743Ab3JPOLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:11:11 -0400
Date: Wed, 16 Oct 2013 07:12:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, devel@driverdev.osuosl.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Archana kumari <archanakumari959@gmail.com>
Subject: Re: [PATCH] [media] staging: media: Fix build for iMON LIRC driver
Message-ID: <20131016141213.GA17567@kroah.com>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com>
 <1381845763-10487-3-git-send-email-treding@nvidia.com>
 <20131016070340.GC11731@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016070340.GC11731@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:03:40AM +0300, Dan Carpenter wrote:
> On Tue, Oct 15, 2013 at 04:02:43PM +0200, Thierry Reding wrote:
> > Add a missing , between parameters in a call to dev_info().
> > 
> 
> Greg already reverted the original patch.
> 
> The original patch wasn't sent to the list.  Archana, use
> scripts/get_maintainer.pl to find out who to send patches to.  Don't
> CC the linux-kernel list though because they don't care about details in
> staging.

Archana sent it through the OPW submission process, which has it's own
mailing list, so as to not bother the driverdev mailing list.  It was
my fault that I missed this error and took the patch, which is why I
reverted it.

thanks,

greg k-h
