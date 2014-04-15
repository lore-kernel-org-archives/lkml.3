Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbaDOE5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:57:47 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54275 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaDOE5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:57:45 -0400
Date: Tue, 15 Apr 2014 00:57:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Message-ID: <20140415045741.GE1863@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
 <20140414154556.GA9552@redhat.com>
 <20140414175236.GB15249@htj.dyndns.org>
 <20140414181421.GC9552@redhat.com>
 <20140414192139.GB16835@htj.dyndns.org>
 <534CA050.8060709@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534CA050.8060709@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 15, 2014 at 10:58:24AM +0800, Li Zefan wrote:
> I know we should allow multiple hierarchies, but why we allow this even
> if sane_behavior is specified?

Oh, because we didn't have unified hierarchy before.  The whole
sane_behavior thing is gonna go away.  It'll be absorbed into unified
hierarchy and probably be handled as a separate filesystem type, so
the current situation is transitional.

Thanks.

-- 
tejun
