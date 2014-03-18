Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaCRQMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:12:34 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:50241 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaCRQMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:12:30 -0400
Date: Tue, 18 Mar 2014 12:12:25 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix a failure path in create_css()
Message-ID: <20140318161225.GD3642@htj.dyndns.org>
References: <53280BAC.5060404@huawei.com>
 <20140318152445.GA3642@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318152445.GA3642@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 11:24:45AM -0400, Tejun Heo wrote:
> On Tue, Mar 18, 2014 at 05:02:36PM +0800, Li Zefan wrote:
> > If online_css() fails, we should remove cgroup files belonging
> > to css->ss.
> > 
> > Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Applied to libata/for-3.14-fixes.

Hmmm... didn't apply cleanly and generated build error.  Looks like
the patch was generated against for-3.15.  Can you please regenerate
the patch against for-3.14-fixes?

Thanks.

-- 
tejun
