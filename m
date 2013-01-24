Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3AXWGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:06:49 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49589 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755245Ab3AXWGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:06:39 -0500
X-Sasl-enc: 4Nn5LV3SX5OIIZCS/jZ7ahgQqAHUmIqoWSUzWEzmbTXD 1359065199
Date: Thu, 24 Jan 2013 14:06:37 -0800
From: Greg KH <greg@kroah.com>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin.Lei@huawei.com, neil.yi@huawei.com, wangyuhua@huawei.com,
        huqiao36@huawei.com, balbi@ti.com, mdharm-usb@one-eyed-alien.net,
        sebastian@breakpoint.cc
Subject: Re: [PATCH 1/1]linux-usb:Define a new macro for USB storage match
 rules
Message-ID: <20130124220637.GA3873@kroah.com>
References: <fe6cc3d21db9.1db9fe6cc3d2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe6cc3d21db9.1db9fe6cc3d2@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 02:04:52PM +0800, fangxiaozhi 00110321 wrote:
> From: fangxiaozhi <huananhu@huawei.com>
> 
> 1. Define a new macro for USB storage match rules: 
>     matching with Vendor ID and interface descriptors.
> 
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> --------------------------------------------------------------------

You sent me two patches, both marked with [1/1], yet they have to be
applied in a specific order.  Which one?  I don't think you want me to
guess :)

Please put the proper order in the patch number, i.e. [1/2], [2/2], and
so on.  If you use git, it will generate these patches, and the numbers,
automatically for you.  Same thing for quilt.  I strongly recommend you
use a tool like this to get this stuff right.

Please resend both of them properly.

thanks,

greg k-h
