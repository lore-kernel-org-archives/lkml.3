Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaFCNC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:02:26 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50618 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFCNCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:02:24 -0400
Date: Tue, 3 Jun 2014 09:02:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 3/3] cgroup: set visible flag only after we've mounted
 the default root
Message-ID: <20140603130220.GC26210@htj.dyndns.org>
References: <538D4956.5050205@huawei.com>
 <538D49A7.2010403@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538D49A7.2010403@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 12:05:59PM +0800, Li Zefan wrote:
> This fixes the failure path, so we won't set the visible flag though
> the mount is failed.

Same rationale.  If the userland knows about it, there's no point in
hiding it.

Thanks.

-- 
tejun
