Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936425Ab3DJSIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:08:13 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:65194 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760271Ab3DJSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:08:11 -0400
Date: Wed, 10 Apr 2013 11:08:06 -0700
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net,
        eranian@google.com, namhyung.kim@lge.com, lizefan@huawei.com,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] perf, cgroup: implement hierarchy support for
 perf_event controller
Message-ID: <20130410180806.GC17641@mtj.dyndns.org>
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365474213-13354-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 07:23:30PM -0700, Tejun Heo wrote:
> perf_event cgroup controller is one of the remaining few with broken
> hierarchy support.  It turns out it's pretty easy to implement - the
> only thing necessary is making perf_cgroup_match() return %true also
> when the cgroup of the current task is a descendant of the event's
> cgroup.  This patchset implements cgroup_is_descendant() and uses it
> to implement hierarchy support in perf_event controller.

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
