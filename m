Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab3GaKox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:44:53 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:36519 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3GaKov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:44:51 -0400
Date: Wed, 31 Jul 2013 06:44:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 3/7] cgroup: restructure the failure path in
 cgroup_write_event_control()
Message-ID: <20130731104448.GH2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C802.7070404@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F8C802.7070404@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:17:06PM +0800, Li Zefan wrote:
> It uses a single label and checks the validity of each pointer. This
> is err-prone, and actually we once had a bug because one of the check
> was insufficient.
> 
> Use multi lables as we do in other places.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Hmm... I usually prefer mix of the two approaches as both extremes
tend to be pretty ugly when things get complex.  I don't mind the
conversion but can you please drop the no longer unnecessary NULL
assignments on variable definitions?

Thanks.

-- 
tejun
