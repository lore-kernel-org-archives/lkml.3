Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3A2TpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:45:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab3A2TpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:45:18 -0500
Date: Tue, 29 Jan 2013 14:45:14 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 1/9] device_cgroup: prepare exception list handling
 functions for two lists
Message-ID: <20130129194514.GW17632@redhat.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.321644928@napanee.usersys.redhat.com>
 <20130129194155.GB6824@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129194155.GB6824@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 11:41:55AM -0800, Tejun Heo wrote:
> On Tue, Jan 29, 2013 at 02:08:00PM -0500, aris@redhat.com wrote:
> > In the following patches, device_cgroup structure will have two sets of
> > behavior and exceptions list (actual one, another with the local settings)
> > so rework the functions to use exception list, not a device_cgroup.
> > 
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> > Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Can you please keep acks across postings?  That makes it a bit easier
> for reviewers.

sure, will do it in the future submissions.

-- 
Aristeu

