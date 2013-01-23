Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3AWA2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:28:00 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:43818 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3AWA16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:27:58 -0500
Date: Tue, 22 Jan 2013 16:27:54 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Message-ID: <20130123002754.GB5359@htj.dyndns.org>
References: <50F7B040.2020906@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F7B040.2020906@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Andrew as scheduler folks are difficult to get response from
 these days and I can't think of anyone else to bother :)

Hello, Li.

The cgroup part looks good to me but it would be great if the
descriptions are more detailed, especially, about why the change is
beneficial or what it's aiming at.  I take it that the shed changes
are necessary to facilitate the later cgroup changes?  Can you please
elaborate how?

The scheduler part of changes are mostly mechanical, so it would be
great if we can get ack from scheduler people and route these together.

Thanks.

-- 
tejun
