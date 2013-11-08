Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3KHCAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:00:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61422 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab3KHCAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:00:50 -0500
Date: Thu, 7 Nov 2013 18:02:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Luigi Semenzato <semenzato@google.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, lliubbo@gmail.com,
        jmarchan@redhat.com, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
Message-ID: <20131108020221.GA28001@kroah.com>
References: <20131107070451.GA10645@bbox>
 <CAA25o9TaWG7Wu6uXwyapKD1oaVYqb47_9Ag7JbT-ZyQT7iaJEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA25o9TaWG7Wu6uXwyapKD1oaVYqb47_9Ag7JbT-ZyQT7iaJEA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 09:06:26AM -0800, Luigi Semenzato wrote:
> If I may add my usual 2c (and some news):
> 
> zram is used by default on all Chrome OS devices.  I can't say how
> many devices, but it's not a small number, google it, and it's an
> important market, low-end laptops for education and the less affluent.
>  It has been available experimentally for well over a year.
> 
> Android 4.4 KitKat is also using zram, to better support devices with
> less than 1 MB RAM.  (That's the news.)
> 
> When comparing the relative advantages of the two subsystems (zram and
> zswap), let's not forget that considerable effort goes into in tuning
> and bug fixing for specific use cases---possibly even more than the
> initial development effort.  Zram has not just been sitting around in
> drivers/staging, it's in serious use.
> 
> If we were to judge systems based merely on theoretical technical
> merit, then we should consider switching en masse to FreeBSD.  (I said
> we should *consider* :).
> 
> I am very familiar with the limitations of zram, but it works well and
> I think it would be wise to keep supporting it.  Besides, it's small
> and AFAICT it interfaces cleanly with the rest of the system, so I
> don't see what the big deal is.

Then please help with getting it merged properly, and out of staging.

thanks,

greg k-h
