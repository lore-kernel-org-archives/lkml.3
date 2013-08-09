Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966951Ab3HIAMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:12:44 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:35536 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966748Ab3HIAMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:12:43 -0400
Date: Thu, 8 Aug 2013 20:12:38 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: use cgroup_subsys_state as
 the primary subsystem interface handle
Message-ID: <20130809001238.GA13427@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375393801-4817-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 05:49:38PM -0400, Tejun Heo wrote:
> So, this patchset converts all cgroup subsystem APIs to deal with
> css's instead of cgroups.  The patchset is fairly large but most of
> the conversions, while being tedious, aren't complex.  At the end of
> series, subsystems no longer make cgroup -> css mapping themselves and
> cgroup_css() - formerly cgroup_subsys_state() - is made internal to
> cgroup core proper.

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
