Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3EWHL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:11:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51826 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3EWHLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:11:24 -0400
Date: Thu, 23 May 2013 00:11:23 -0700 (PDT)
Message-Id: <20130523.001123.1597846956917976677.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sasha.levin@oracle.com
Subject: Re: [PATCH V2] virtio_net: enable napi for all possible queues
 during open
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369202638-17660-1-git-send-email-jasowang@redhat.com>
References: <1369202638-17660-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 22 May 2013 14:03:58 +0800

> Commit 55257d72bd1c51f25106350f4983ec19f62ed1fa (virtio-net: fill only rx
> queues which are being used) only does the napi enabling during open for
> curr_queue_pairs. This will break multiqueue receiving since napi of new queues
> were still disabled after changing the number of queues.
> 
> This patch fixes this by enabling napi for all possible queues during open.
> 
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks.
