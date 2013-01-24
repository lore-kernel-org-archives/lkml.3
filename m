Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3AXWBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:01:39 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:34661 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3AXWBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:01:31 -0500
Date: Thu, 24 Jan 2013 14:01:25 -0800
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v2 1/4] device_cgroup: prepare exception list handling
 functions for two lists
Message-ID: <20130124220125.GV2373@mtj.dyndns.org>
References: <20130124194957.198022148@napanee.usersys.redhat.com>
 <20130124194957.375712635@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124194957.375712635@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 02:49:58PM -0500, aris@redhat.com wrote:
> In the following patches, device_cgroup structure will have two sets of
> behavior and exceptions list (actual one, another with the local settings)
> so rework the functions to use exception list, not a device_cgroup.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
