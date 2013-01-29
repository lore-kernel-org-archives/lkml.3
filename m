Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3A2Tog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:44:36 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63100 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3A2Tod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:44:33 -0500
Date: Tue, 29 Jan 2013 11:44:29 -0800
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 2/9] devcg: reorder device exception functions
Message-ID: <20130129194429.GC6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.567563910@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129190759.567563910@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 02:08:01PM -0500, aris@redhat.com wrote:
> In preparation for the next patch, reorder dev_exception_add() and
> dev_exception_rm().

It would be nice to have something like "this change doesn't introduce
any functional changes".

> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
