Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3CSVap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:30:45 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:57465 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab3CSVan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:30:43 -0400
Date: Tue, 19 Mar 2013 14:30:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v5 0/4] devcg: introduce proper hierarchy support
Message-ID: <20130319213039.GO3042@htj.dyndns.org>
References: <20130215165543.131282532@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215165543.131282532@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:55:43AM -0500, Aristeu Rozanski wrote:
> This patchset implements device cgroup hierarchy. Exceptions will be
> propagated down in the tree and local preferences will be re-evaluated
> everytime a change in its parent occours, reapplying them if it's still
> possible.

Applied to cgroup/for-3.10.

Thanks!

-- 
tejun
