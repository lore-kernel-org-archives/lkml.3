Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab3FNDtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 23:49:06 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:43500 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3FNDtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 23:49:04 -0400
Date: Thu, 13 Jun 2013 20:48:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cpuset: rename cont to cgrp
Message-ID: <20130614034858.GB31533@htj.dyndns.org>
References: <51BA8B83.8090607@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BA8B83.8090607@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 11:18:27AM +0800, Li Zefan wrote:
> Cont is short for container. control group was named process container
> at first, but then people found container already has a meaning in
> linux kernel.
> 
> Clean up the leftover variable name @cont.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.11-cpuset.

Thanks.

-- 
tejun
