Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaEMXz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:55:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaEMXzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:55:24 -0400
Date: Tue, 13 May 2014 16:58:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: stable@vger.kernel.org, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, miaox@cn.fujitsu.com,
        tangchen <tangchen@cn.fujitsu.com>
Subject: Re: [RESEND v2 PATCH 0/2] Bug fix in aio ring page migration
Message-ID: <20140513235840.GD29623@kroah.com>
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com>
 <53217E46.3060100@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53217E46.3060100@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 05:45:42PM +0800, Gu Zheng wrote:
> This patchset has been applied to linux-next, and these problems also exist
> in 3.12.y and 3.13.y stable tree.
> So please merge this patchset to 3.12.y and 3.13.y stable tree.
> 
> commit 692c9b8c5ee8d263bb8348171f0bebd3d84eb2c1
> Author: Tang Chen <tangchen@cn.fujitsu.com>
> Date:   Mon Mar 10 16:15:33 2014 +0800
> 
>     aio, memory-hotplug: Fix confliction when migrating and accessing ring pages.
> 
> commit e0f5e0add36d2e3c456cf2f4283673ed834b3c24
> Author: Tang Chen <tangchen@cn.fujitsu.com>
> Date:   Mon Mar 10 16:15:34 2014 +0800
> 
>     aio, mem-hotplug: Add memory barrier to aio ring page migration.
> 
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/fs/aio.c?id=692c9b8c5ee8d263bb8348171f0bebd3d84eb2c1
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/fs/aio.c?id=e0f5e0add36d2e3c456cf2f4283673ed834b3c24
> 
> https://lkml.org/lkml/2014/3/10/56
> https://lkml.org/lkml/2014/3/10/58

I don't see these in Linus's tree, what happened?

thanks,

greg k-h
