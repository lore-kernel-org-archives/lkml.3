Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaBKQ5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:57:43 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:48217 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBKQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:57:41 -0500
Date: Tue, 11 Feb 2014 11:57:38 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: convert to kernfs
Message-ID: <20140211165738.GG24490@htj.dyndns.org>
References: <1390953285-16360-1-git-send-email-tj@kernel.org>
 <52F9EC39.40504@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F9EC39.40504@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:24:09PM +0800, Li Zefan wrote:
> Acked-by: Li Zefan <lizefan@huawei.com>

Updated the patches so that they apply on top of the idr locking fix
and applied the series to cgroup/for-3.15.

Thanks!

-- 
tejun
