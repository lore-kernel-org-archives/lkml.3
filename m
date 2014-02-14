Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaBNFKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 00:10:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53054 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaBNFKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 00:10:09 -0500
Date: Fri, 14 Feb 2014 00:10:04 -0500 (EST)
Message-Id: <20140214.001004.838095636844604151.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, jasowang@redhat.com,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        qinchuanyu@huawei.com, joern@logfs.org, anatol.pomozov@gmail.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH net 1/3] kref: add kref_sub_return
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140214000320.GC15564@kroah.com>
References: <20140212.230506.1305102368255894549.davem@davemloft.net>
	<20140212.230953.770721407102955395.davem@davemloft.net>
	<20140214000320.GC15564@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 21:10:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Thu, 13 Feb 2014 16:03:20 -0800

> So how about just "open coding" a kref for this structure, as it wants
> something that doesn't fit into the kref model, and should be pretty
> simple to do (you can ensure you get the locking right, unlike almost
> all users of krefs, as Al Viro constantly points out to me...)

They redid their patches meanwhile to use their own atomic_t.
