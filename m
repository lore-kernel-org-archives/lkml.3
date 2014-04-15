Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaDOMvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:51:21 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45993 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbaDOMvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:51:15 -0400
Date: Tue, 15 Apr 2014 08:51:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: print pretty format in /proc/cgroups
Message-ID: <20140415125111.GG1863@htj.dyndns.org>
References: <1397566065-3028-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397566065-3028-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 08:47:45PM +0800, Jianyu Zhan wrote:
> I found that /proc/cgroups printed format has ugly alignment(see below).
> 
> This patch confines every field in fixed-width(16 actually) range.
> Though MAX_CGROUP_TYPE_NAMELEN is 32, but currently no subsystem
> has name width more than 10, so 16 is a moderate width; besides, 16
> figures could accomandate enormous huge number, so no need to worry
> that these fields would clobber each other.

The problem there is that there could be programs / scripts parsing it
assuming single tab between entries.  It surely is ugly but do we
care?

Thanks.

-- 
tejun
