Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3HPRHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:07:07 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:48838 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3HPRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:07:03 -0400
Date: Fri, 16 Aug 2013 13:06:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: change cgroup_from_id() to css_from_id()
Message-ID: <20130816170659.GM2505@htj.dyndns.org>
References: <520DCF2C.1020903@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520DCF2C.1020903@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Fri, Aug 16, 2013 at 03:05:16PM +0800, Li Zefan wrote:
> +/**
> + * css_from_id - lookup css by id
> + * @ss: cgroup subsys to be looked into
> + * @id: the cgroup id
> + *
> + * Returns the css if there's valid one with @id, otherwise returns NULL.
> + * Should be called under rcu_read_lock().
> + */
> +struct cgroup_subsys_state *css_from_id(struct cgroup_subsys *ss, int id)

Can we please do css_from_id(int id, struct cgroup_subsys *ss)
instead?

Thanks.

-- 
tejun
