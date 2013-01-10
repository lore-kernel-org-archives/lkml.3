Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3AJUNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:13:18 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39212 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3AJUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:13:17 -0500
Date: Thu, 10 Jan 2013 12:13:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: use new hashtable implementation
Message-ID: <20130110201312.GN20454@htj.dyndns.org>
References: <50EE3A47.9030005@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EE3A47.9030005@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 11:49:27AM +0800, Li Zefan wrote:
> Switch cgroup to use the new hashtable implementation. No functional changes.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.9.  Thanks!

-- 
tejun
