Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3HANac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:30:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53432 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3HANa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:30:28 -0400
Date: Thu, 1 Aug 2013 09:30:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] cgroup: restructure the failure path in
 cgroup_write_event_control()
Message-ID: <20130801133022.GD24966@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C802.7070404@huawei.com>
 <20130731104448.GH2810@htj.dyndns.org>
 <51F9BF33.4060306@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F9BF33.4060306@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 09:51:47AM +0800, Li Zefan wrote:
> It uses a single label and checks the validity of each pointer. This
> is err-prone, and actually we had a bug because one of the check was
> insufficient.
> 
> Use multi lables as we do in other places.
> 
> v2:
> - drop initializations of local variables.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
