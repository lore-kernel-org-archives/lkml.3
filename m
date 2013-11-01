Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3KAONr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:13:47 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:55597 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3KAONp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:13:45 -0400
MIME-Version: 1.0
In-Reply-To: <52736C52.8080600@redhat.com>
References: <20131019110539.GA25167@gmail.com>
	<4fdb273ab0b1e7514f119d7e619ac708d2277d34.1383220461.git.rashika.kheria@gmail.com>
	<52736C52.8080600@redhat.com>
Date: Fri, 1 Nov 2013 19:43:44 +0530
Message-ID: <CAMpEsFEwKuTwr8DqAfa+8fbgKbnc=9BvB6s-Y=A5vS6a-BRGsA@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] Staging: zram: Fix decrement of variable by
 calling bdput()
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: opw-kernel <opw-kernel@googlegroups.com>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 2:24 PM, Jerome Marchand <jmarchan@redhat.com> wrote:
>
> On 10/31/2013 12:58 PM, Rashika Kheria wrote:
> > As suggested by Jerome Marchand "The code in reset_store get the block device
> The credit should actually go to Minchan. He found the bug. I merely
> explained it.
>
> > (bdget_disk()) but it does not put it (bdput()) when it's done using it.
> > The usage count is therefore incremented but never decremented."
> >
> > This patch also puts bdput() for all error cases.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
>
> This version finally looks good. Thanks for your effort.
>
> Acked-by: Jerome Marchand <jmarchan@redhat.com>
>
>

Hi,

Thanks Minchan and Jerome for all you support and patience.
Your guidance helped me learn more about zram and kernel coding style
in general. :)

Thanks,
-- 
Rashika Kheria
B.Tech CSE
IIIT Hyderabad
