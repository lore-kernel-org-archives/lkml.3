Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbaGIT5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:57:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58381 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbaGIT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:57:29 -0400
Date: Wed, 9 Jul 2014 15:57:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3 03/12] cpuset: update cs->effective_{cpus,mems} when
 config changes
Message-ID: <20140709195726.GB21090@htj.dyndns.org>
References: <53BD0174.4060002@huawei.com>
 <53BD01A1.2060302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD01A1.2060302@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 04:47:29PM +0800, Li Zefan wrote:
> +static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)

Let's please use a variable name which clearly indicates that it's a
temp place.  Something like @cpus_buf?  Ditto with mems.

Thanks.

-- 
tejun
