Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbaIRRXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:23:41 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:48974 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbaIRRX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:23:29 -0400
Date: Thu, 18 Sep 2014 13:23:25 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: use a per-cgroup work for release agent
Message-ID: <20140918172325.GC13573@mtj.dyndns.org>
References: <541A927B.8010308@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541A927B.8010308@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 04:06:19PM +0800, Zefan Li wrote:
> Instead of using a global work to schedule release agent on removable
> cgroups, we change to use a per-cgroup work to do this, which makes
> the code much simpler.
> 
> v2: use a dedicated work instead of reusing css->destroy_work. (Tejun)
> 
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
