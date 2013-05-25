Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3EYMWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 08:22:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab3EYMWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 08:22:18 -0400
Date: Sat, 25 May 2013 05:22:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org, Li Zefan <lizefan@huawei.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] module: use a macro instead of platform_driver_register
Message-ID: <20130525122240.GC3746@kroah.com>
References: <51A040D2.20708@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A040D2.20708@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 12:40:50PM +0800, Libo Chen wrote:
> 
> I found a lot of mistakes using struct platform_driver without owner
> so I make a macro instead of the function platform_driver_register.
> It can set owner in it, then guys don`t care about module owner again.
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Nice job, that's the better way to fix this, I'll queue it up for 3.11.

thanks,

greg k-h
