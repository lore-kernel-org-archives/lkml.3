Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3BORXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:23:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3BORXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:23:08 -0500
Date: Fri, 15 Feb 2013 11:23:01 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v5 0/4] devcg: introduce proper hierarchy support
Message-ID: <20130215172301.GA23344@sergelap>
References: <20130215165543.131282532@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215165543.131282532@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> This patchset implements device cgroup hierarchy. Exceptions will be
> propagated down in the tree and local preferences will be re-evaluated
> everytime a change in its parent occours, reapplying them if it's still
> possible.

Thanks Aristeu!  I may not be able to look at it until monday, but will
take a close look.

-serge
