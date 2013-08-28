Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3H1EeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 00:34:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3H1Ed5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 00:33:57 -0400
Date: Tue, 27 Aug 2013 21:36:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: balbi@ti.com, swarren@wwwdotorg.org, USB <linux-usb@vger.kernel.org>,
        linux-tegra@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 3/4] usb: phy-tegra-usb: use platform_{get,set}_drvdata()
Message-ID: <20130828043616.GB21756@kroah.com>
References: <521C5EF3.2090907@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521C5EF3.2090907@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 04:10:27PM +0800, Libo Chen wrote:
> 
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/phy/phy-tegra-usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

This patch doesn't apply to my tree :(
