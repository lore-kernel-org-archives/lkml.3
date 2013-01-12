Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3ALAWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:22:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:39166 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab3ALAWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:22:19 -0500
Date: Fri, 11 Jan 2013 16:22:17 -0800
From: Greg KH <greg@kroah.com>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, neil.yi@huawei.com, wangyuhua@huawei.com,
        huqiao36@huawei.com, balbi@ti.com, mdharm-usb@one-eyed-alien.net,
        sebastian@breakpoint.cc
Subject: Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Message-ID: <20130112002217.GA26346@kroah.com>
References: <fe8cd5406b9b.6b9bfe8cd540@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe8cd5406b9b.6b9bfe8cd540@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 05:57:44PM +0800, fangxiaozhi 00110321 wrote:
> From: fangxiaozhi <huananhu@huawei.com>
> 
> 1. Optimize the match rules with new macro for Huawei USB storage devices, 
>    to avoid to load USB storage driver for the modem interface 
>    with Huawei devices.
> 2. Add to support new switch command for new Huawei USB dongles.

I don't see a 1/2 patch in this series, yet I see two different 1/1
patches.

Can you resend all of your outstanding patchs, in the correct order,
with the correct numbering, so I know what order to apply them in?

thanks,

greg k-h
