Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaFYDrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 23:47:31 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:62991 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaFYDr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 23:47:29 -0400
Message-ID: <53AA4595.6030401@huawei.com>
Date: Wed, 25 Jun 2014 11:44:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] cgroup: fix a typo in Documentation/cgroups/cgroups.txt
References: <1403667025-13422-1-git-send-email-chenhanxiao@cn.fujitsu.com>
In-Reply-To: <1403667025-13422-1-git-send-email-chenhanxiao@cn.fujitsu.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.53AA45A0.0060,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 91327f41cb7ba427acdd7f2a25c559ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/25 11:30, Chen Hanxiao wrote:
> s/iff/if
> 

This is not a typo. iff == if and only if.

> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---
>  Documentation/cgroups/cgroups.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index 821de56..b614f42 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -562,7 +562,7 @@ cgroup_for_each_descendant_pre() for details.
>  void css_offline(struct cgroup *cgrp);
>  (cgroup_mutex held by caller)
>  
> -This is the counterpart of css_online() and called iff css_online()
> +This is the counterpart of css_online() and called if css_online()
>  has succeeded on @cgrp. This signifies the beginning of the end of
>  @cgrp. @cgrp is being removed and the subsystem should start dropping
>  all references it's holding on @cgrp. When all references are dropped,
> 

