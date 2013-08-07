Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3HGOMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:12:15 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:44777 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3HGOMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:12:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130803155351.GK2580@book.gsilab.sittig.org>
References: <1375255292-11288-1-git-send-email-a13xp0p0v88@gmail.com>
	<20130803155351.GK2580@book.gsilab.sittig.org>
Date: Wed, 7 Aug 2013 18:12:13 +0400
Message-ID: <CAF0T0X5YU=7Q=SmRvQ6Nr-awmext5EAk7SqtuqeLcySo1jazYw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 2/5] dma: mpc512x: add support for peripheral transfers
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Alexander Popov <a13xp0p0v88@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Arnd Bergmann <arnd@arndb.de>, Anatolij Gustschin <agust@denx.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/3 Gerhard Sittig <gsi@denx.de>:
> On Wed, Jul 31, 2013 at 11:21 +0400, Alexander Popov wrote:
>>
> You don't provide a lot of information to those you want to
> receive feedback from.  You should keep a history and list the
> changes between versions.  And you may want to somehow link this
> v3 to its predecessor -- especially when you only send part of
> the series and assume that reviewers may know where to find the
> remainder.
>
> Please help those persons you want to get help from.

Thanks. Now I see how to collaborate via mailing lists properly.

> I think it's unfortunate to attribute the "will access
> peripheral" to the channel instead of the transfer job, and to
> set the flag from within the device control callback, and to
> nevery clear the flag (what will happen if a channel gets freed
> and reallocated by some other client?).
>
> I think that the peripheral access is an attribute of the
> transfer job, and should be setup in the prep routines (both set
> and cleared, depending on what gets setup).  This would be more
> robust and more readable (read: maintainable) in my eyes.

Yes. I agree, I will implement it and offer differences from RFC v2
in the initial topic.

Best regards,
Alexander.
