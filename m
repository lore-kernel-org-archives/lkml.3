Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaBXXUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:20:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48269 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaBXXUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:20:43 -0500
Date: Mon, 24 Feb 2014 18:20:41 -0500 (EST)
Message-Id: <20140224.182041.1959352738873712711.davem@davemloft.net>
To: jasowang@redhat.com
Cc: rusty@rustcorp.com.au, mst@redhat.com, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sri@us.ibm.com
Subject: Re: [PATCH net V2] virtio-net: alloc big buffers also when guest
 can receive UFO
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392959284-11399-1-git-send-email-jasowang@redhat.com>
References: <1392959284-11399-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2014 15:20:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 21 Feb 2014 13:08:04 +0800

> We should alloc big buffers also when guest can receive UFO
> pakcets to let the big packets be fit into guest rx buffer.
> 
> Fixes 5c5167515d80f78f6bb538492c423adcae31ad65
> (virtio-net: Allow UFO feature to be set and advertised.)
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V1:
> - tweak the commit log

Applied with commit message fixes, thanks.
