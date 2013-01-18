Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3ARXmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:42:31 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:52653 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab3ARXma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:42:30 -0500
Date: Fri, 18 Jan 2013 15:42:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, neil.yi@huawei.com, wangyuhua@huawei.com,
        huqiao36@huawei.com, balbi@ti.com, mdharm-usb@one-eyed-alien.net,
        sebastian@breakpoint.cc
Subject: Re: USB: storage: optimize the matching rules and support new switch
 command for Huawei USB storage devices
Message-ID: <20130118234226.GA30704@kroah.com>
References: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe8c85797e7f.7e7ffe8c8579@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:55:48AM +0800, fangxiaozhi 00110321 wrote:
> 
> From: fangxiaozhi <huananhu@huawei.com>
> 
> 1. Optimize the matching rules with new macro for Huawei USB storage
>    devices, to avoid to load USB storage driver for the modem interface
>    with Huawei devices.
> 2. Add to support new switch command for new Huawei USB dongles.
> 
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>

Next time, please always use the scripts/checkpatch.pl tool to find any
problems you might have made in your patch (you had trailing whitespace
in this one, which I have fixed.)

Also, you might want to use git, it makes creating the patches easier,
that way you don't end up with lines in the patch like this one:

> Binary files linux-3.8-rc3_orig/drivers/usb/storage/initializers.o and linux-3.8-rc3/drivers/usb/storage/initializers.o differ

thanks,

greg k-h
