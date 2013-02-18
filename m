Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab3BRKWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:22:09 -0500
Received: from shutemov.name ([204.155.152.216]:37813 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505Ab3BRKWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:22:07 -0500
Date: Mon, 18 Feb 2013 12:24:11 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fail if monitored file and event_control are in
 different cgroup
Message-ID: <20130218102411.GA3394@shutemov.name>
References: <5121C68F.1000309@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5121C68F.1000309@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 02:13:35PM +0800, Li Zefan wrote:
> If we pass fd of memory.usage_in_bytes of cgroup A to cgroup.event_control
> of cgroup B, then we won't get memory usage notification from A but B!
> 
> What's worse, if A and B are in different mount hierarchy, we'll end up
> accessing NULL pointer!
> 
> Disallow this kind of invalid usage.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
