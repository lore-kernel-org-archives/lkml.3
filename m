Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaBZSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:25:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaBZSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:25:28 -0500
Date: Wed, 26 Feb 2014 10:27:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: vinayakm.list@gmail.com
Cc: arve@android.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: lowmemorykiller: neglect swap cached
 pages in other_file
Message-ID: <20140226182703.GA32515@kroah.com>
References: <1393438233-2759-1-git-send-email-vinayakm.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393438233-2759-1-git-send-email-vinayakm.list@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 11:40:33PM +0530, vinayakm.list@gmail.com wrote:
> From: Vinayak Menon <vinayakm.list@gmail.com>
> 
> With ZRAM enabled it is observed that lowmemory killer
> doesn't trigger properly. swap cached pages are
> accounted in NR_FILE, and lowmemorykiller considers
> this as reclaimable and adds to other_file. But these
> pages can't be reclaimed unless lowmemorykiller triggers.
> So subtract swap pages from other_file.
> 
> Signed-off-by: Vinayak Menon <vinayakm.list@gmail.com>
> ---
>  drivers/staging/android/lowmemorykiller.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

You sent 2 patches, both different, which should I apply?

How about I delete both and wait for a proper "v3" that specifies
exactly what is going on here...
