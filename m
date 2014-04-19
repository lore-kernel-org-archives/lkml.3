Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaDSM5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 08:57:44 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:65040 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDSM5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 08:57:10 -0400
Date: Sat, 19 Apr 2014 08:57:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Takeshi Misawa <jeantsuru@gmail.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup:cgroup_mount: Fix uninitialized warning
Message-ID: <20140419125706.GA3277@htj.dyndns.org>
References: <CABYERD89BtTTJh8j0d0kvCU-xNEy8YJhFaPFr+hjuy5gWQoVNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABYERD89BtTTJh8j0d0kvCU-xNEy8YJhFaPFr+hjuy5gWQoVNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 09:52:14PM +0900, Takeshi Misawa wrote:
> This patch fixes the following warning.
> 
> kernel/cgroup.c: In function ‘cgroup_mount’:
> kernel/cgroup.c:1609:13: warning: ‘root’ may be used uninitialized in this
> function

Which compiler are you using?  This is a spurious warning which the
compiler should be able to avoid pretty easily.

Thanks.

-- 
tejun
