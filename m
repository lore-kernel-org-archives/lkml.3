Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750826Ab3HSNx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:53:59 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:48741 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3HSNx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:53:58 -0400
Date: Mon, 19 Aug 2013 09:53:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: change cgroup_from_id() to css_from_id()
Message-ID: <20130819135353.GC6176@htj.dyndns.org>
References: <520DCF2C.1020903@huawei.com>
 <20130816170659.GM2505@htj.dyndns.org>
 <52117D64.1010709@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52117D64.1010709@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 10:05:24AM +0800, Li Zefan wrote:
> Now we want cgroup core to always provide the css to use to the
> subsystems, so change this API to css_from_id().
> 
> Uninline css_from_id(), because it's getting bigger and cgroup_css()
> has been unexported.
> 
> While at it, remove the #ifdef, and shuffle the order of the args.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
