Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaGIQrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:47:45 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:41039 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaGIQrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:47:43 -0400
Date: Wed, 9 Jul 2014 12:47:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3 01/12] cpuset: add cs->effective_cpus and
 cs->effective_mems
Message-ID: <20140709164740.GE11193@htj.dyndns.org>
References: <53BD0174.4060002@huawei.com>
 <53BD0187.9060309@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD0187.9060309@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 04:47:03PM +0800, Li Zefan wrote:
> +	/* user-configured CPUs and Memory Nodes allow to tasks */
                                                allowed
> +	cpumask_var_t cpus_allowed;
> +	nodemask_t mems_allowed;
> +
> +	/* effective CPUs and Memory Nodes allow to tasks */

ditto.

Thanks.

-- 
tejun
