Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3H1Edu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 00:33:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3H1Eds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 00:33:48 -0400
Date: Tue, 27 Aug 2013 21:36:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: balbi@ti.com, stern@rowland.harvard.edu, USB <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 2/4] usb: r8a66597-hcd: use platform_{get,set}_drvdata()
Message-ID: <20130828043607.GA21756@kroah.com>
References: <521C5EEE.1080505@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521C5EEE.1080505@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 04:10:22PM +0800, Libo Chen wrote:
> 
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/host/r8a66597-hcd.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

This patch doesn't apply to my tree :(

