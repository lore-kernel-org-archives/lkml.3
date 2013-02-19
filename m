Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084Ab3BSUYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:24:53 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62867 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758799Ab3BSUYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:24:51 -0500
Date: Tue, 19 Feb 2013 12:24:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 13/15] workqueue: also record worker in work->data if
 running&&queued
Message-ID: <20130219202447.GY17414@htj.dyndns.org>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
 <1361203940-6300-14-git-send-email-laijs@cn.fujitsu.com>
 <20130218195023.GJ17414@htj.dyndns.org>
 <CACvQF52DsDXopHEdDAy42nY78+O6sr3RUd3s3Ehsd1Per6ms7w@mail.gmail.com>
 <20130219192750.GT17414@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219192750.GT17414@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Tue, Feb 19, 2013 at 11:27:50AM -0800, Tejun Heo wrote:
> 0001 is problematic because it adds a hash lookup which isn't
> necessary.  In this series, it's okay as the later lookup is removed
> eventually but without that, I don't think it's a good idea to apply
> 0001.
> 
> 0002 looks good to me.
> 
> 0005, I'm not sure what the benefit would be without later changes.
> 
> 0006-0008 yeah, probably.
> 
> I'll try to apply them on top of wq/for-3.9.

So, I picked and applied 2, 6-8 on a temp branch.  FYI, note that I'm
currently sitting on top of a bunch of patches implementing custom
worker_pools and likely to prioritize them over other conflicting
changes.  I'm expecting to send these out in a week or so.

Thanks.

-- 
tejun
