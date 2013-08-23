Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3HWFVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 01:21:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57283 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab3HWFVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 01:21:43 -0400
Date: Thu, 22 Aug 2013 22:21:42 -0700 (PDT)
Message-Id: <20130822.222142.765878355588087442.davem@davemloft.net>
To: rui.xiang@huawei.com
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-usb@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-mm@kvack.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] fs: use inode_set_user to set uid/gid of inode
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377226118-43756-3-git-send-email-rui.xiang@huawei.com>
References: <1377226118-43756-1-git-send-email-rui.xiang@huawei.com>
	<1377226118-43756-3-git-send-email-rui.xiang@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 22 Aug 2013 22:21:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rui Xiang <rui.xiang@huawei.com>
Date: Fri, 23 Aug 2013 10:48:38 +0800

> Use the new interface to set i_uid/i_gid in inode struct.
> 
> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>

For the networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
