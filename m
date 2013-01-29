Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3A2Tws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:52:48 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48449 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3A2Twq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:52:46 -0500
Date: Tue, 29 Jan 2013 11:52:40 -0800
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 6/9] devcg: use css_online and css_offline
Message-ID: <20130129195240.GG6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190800.123213034@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129190800.123213034@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 02:08:05PM -0500, aris@redhat.com wrote:
> Allocate resources and change behavior only when online.
> This patch is in preparation for hierarchy support.

I think the description is a bit lacking.  We need this because we
need to reliably determine whether a certain node is on the hierarchy
or not for config propagation and inheritance.  It would be nice if
you explain the synchornization implications.

> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
