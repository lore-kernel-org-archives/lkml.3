Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaBLOah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:30:37 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38137 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaBLOag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:30:36 -0500
Date: Wed, 12 Feb 2014 09:30:24 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET v2 cgroup/for-3.15] cgroup: cleanups after kernfs
 conversion
Message-ID: <20140212143024.GK24490@htj.dyndns.org>
References: <1391877509-10855-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391877509-10855-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 11:38:21AM -0500, Tejun Heo wrote:
> Hello,
> 
> This is v2 of cleanups-after-kernfs-conversion patchset.  Nothing
> really changed since the last take[L]. It just got rebased on top of
> the updated patches.
> 
> This patchset does a number of cleanups which are possible now that
> cgroup is converted to kernfs.  This patchset contains the following
> eight patches.

Applied to cgroup/for-3.15.

Thanks.

-- 
tejun
