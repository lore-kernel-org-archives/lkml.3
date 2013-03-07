Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667Ab3CGSeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:34:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab3CGSd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:33:59 -0500
Date: Thu, 7 Mar 2013 19:32:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: lockdep trace from prepare_bprm_creds
Message-ID: <20130307183213.GA18022@redhat.com>
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307182140.GF29601@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307182140.GF29601@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07, Tejun Heo wrote:
>
> On Thu, Mar 07, 2013 at 10:01:39AM -0800, Tejun Heo wrote:
> >
> > Another possibility is moving cgroup_lock outside threadgroup_lock(),
> > which was impossible before because of cgroup_lock abuses in specific
> > controller implementations but most of that have been updated and we
> > should now be pretty close to being able to make cgroup_lock outer to
> > most other locks.  Appending a completely untested patch below.
>
> This probably doesn't help as the dependency involves i_mutex.

Confused... why?

Oleg.

