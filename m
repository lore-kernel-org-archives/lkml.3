Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab3KJPm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:42:56 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56957 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3KJPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:42:54 -0500
Date: Sun, 10 Nov 2013 07:45:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com, Minchan Kim <minchan@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v10] Staging: zram: Fix memory leak by refcount mismatch
Message-ID: <20131110154522.GA28926@kroah.com>
References: <20131019110539.GA25167@gmail.com>
 <1383314769-3667-1-git-send-email-rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383314769-3667-1-git-send-email-rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 07:36:09PM +0530, Rashika Kheria wrote:
> As suggested by Minchan Kim and Jerome Marchand "The code in reset_store
> get the block device (bdget_disk()) but it does not put it (bdput()) when
> it's done using it. The usage count is therefore incremented but never
> decremented."
> 
> This patch also puts bdput() for all error cases.
> 
> Acked-by: Minchan Kim <minchan@kernel.org>
> Acked-by: Jerome Marchand <jmarchan@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
> 
> This revision fixes the following issue of the previous revision-
> Incorrect Subject Line

I'm a bit confused now, I see three different zram patches from you,
with different subjects, are they all now just in one patch, this one?

Can you just send me the outstanding zram patches that you have gotten
acks from that you want applied, as I'm lost here.

thanks,

greg "easily confused" k-h
