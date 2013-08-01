Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3HABMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:12:02 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28198 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3HABL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:11:59 -0400
Message-ID: <51F9B5D8.4080707@huawei.com>
Date: Thu, 1 Aug 2013 09:11:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 6/7] cgroup: rename current_css_set_cg_links
References: <51F8C7C5.9040608@huawei.com> <51F8C83F.6010407@huawei.com> <20130731113857.GM2810@htj.dyndns.org>
In-Reply-To: <20130731113857.GM2810@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/31 19:38, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jul 31, 2013 at 04:18:07PM +0800, Li Zefan wrote:
>> As we've renamed css_set->cg_links to css_set->cgrp_links (See commit
>> 69d0206c79 "cgroup: bring some sanity to naming around cg_cgroup_link"),
>> it's better to also rename the debug file.
>>
>> As the "debug" cgroup subsystem is for debug only and acts as a sample
>> on how to write a cgroup subsystem, it's fine to change the interface.
> 
> I'd rather not do this.  It doesn't really buy us anything and stuff
> like cgrp_links isn't interesting to actual controllers anyway.
> 

not a big deal

