Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaC1ULM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:11:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40465 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaC1ULK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:11:10 -0400
Date: Fri, 28 Mar 2014 16:11:08 -0400 (EDT)
Message-Id: <20140328.161108.883291931619730975.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Subject: Re: [PATCH net] vhost: validate vhost_get_vq_desc return value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395917517-30937-1-git-send-email-mst@redhat.com>
References: <1395917517-30937-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Mar 2014 13:11:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 27 Mar 2014 12:53:37 +0200

> vhost fails to validate negative error code
> from vhost_get_vq_desc causing
> a crash: we are using -EFAULT which is 0xfffffff2
> as vector size, which exceeds the allocated size.
> 
> The code in question was introduced in commit
> 8dd014adfea6f173c1ef6378f7e5e7924866c923
>     vhost-net: mergeable buffers support
> 
> CVE-2014-0055
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> This is needed in -stable.

Applied and queued up for -stable, thanks Michael.
