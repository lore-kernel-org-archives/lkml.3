Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3EQDuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:50:32 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:40854 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754850Ab3EQDu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:50:28 -0400
X-Sasl-enc: +Ptvms8EU0kxiNiVcr0UeujLSJnbBQRW9P5Yf+DsSVVQ 1368762118
Date: Thu, 16 May 2013 17:34:28 -0700
From: Greg KH <greg@kroah.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: stern@rowland.harvard.edu, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        lizefan@huawei.com, Libo Chen <chenlibo.3@gmail.com>
Subject: Re: [PATCH 4/4] usb: tilegx: fix memleak when create hcd fail
Message-ID: <20130517003428.GA10235@kroah.com>
References: <1368075491-38728-1-git-send-email-libo.chen@huawei.com>
 <1368075491-38728-5-git-send-email-libo.chen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368075491-38728-5-git-send-email-libo.chen@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 12:58:11PM +0800, Libo Chen wrote:
> From: Libo Chen <chenlibo.3@gmail.com>
> 
> When usb_create_hcd fail, we should call gxio_usb_host_destroy
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/host/ohci-tilegx.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)

This patch doesn't apply at all, care to refresh it?

thanks,

greg k-h
