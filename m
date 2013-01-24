Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161009Ab3AXWGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:06:05 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:45557 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab3AXWF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:05:58 -0500
Date: Thu, 24 Jan 2013 14:05:53 -0800
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v2 2/4] device_cgroup: keep track of local group settings
Message-ID: <20130124220553.GW2373@mtj.dyndns.org>
References: <20130124194957.198022148@napanee.usersys.redhat.com>
 <20130124194957.519573358@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124194957.519573358@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 02:49:59PM -0500, aris@redhat.com wrote:
> In preparation for better hierarchy support, it's needed to retain the local
> settings in order to try to reapply them after a propagated change if they're
> still valid.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

Looks okay to me but it would be better if you separate out moving
dev_exception_rm() above dev_exception_add() into a separate patch.
It currently mixes functional and non-functional changes which isn't
very nice.

Thanks.

-- 
tejun
