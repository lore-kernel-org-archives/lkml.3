Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbaDKONt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:13:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbaDKONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:13:48 -0400
Date: Fri, 11 Apr 2014 07:16:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MCB fixes for 3.15-rc1
Message-ID: <20140411141634.GE3343@kroah.com>
References: <20140411064829.GA11402@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411064829.GA11402@jtlinux>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 08:48:40AM +0200, Johannes Thumshirn wrote:
> Hi Greg,
> 
> Please pull this change for drivers/mcb.
> 
> Thanks
> 	Johannes
> 
> --
> 
> The following changes since commit 9e897e13bd46fa03485468609741974259a8c573:
> 
>   Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd (2014-04-10 14:33:02 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://github.com/morbidrsa/linux.git mcb
> 
> for you to fetch changes up to e383c2430770c4bb080b4915826f34b729b33bbc:
> 
>   drivers: mcb: fix memory leak in chameleon_parse_cells() error path (2014-04-11 08:37:37 +0200)

I really don't like taking git pull requests, and will not take one from
a non-kernel.org tree, nor one without a signed tag.

For just a single patch like this, just send it through email.  Much
faster and simpler.

Oh, and go get a kernel.org account :)

thanks,

greg k-h
