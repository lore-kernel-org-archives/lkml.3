Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3EEU6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 16:58:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47982 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3EEU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 16:58:29 -0400
Date: Sun, 05 May 2013 16:58:25 -0400 (EDT)
Message-Id: <20130505.165825.1787385657172692387.davem@davemloft.net>
To: stephen@networkplumber.org
Cc: jasowang@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akong@redhat.com
Subject: Re: [PATCH] virtio: don't expose u16 in userspace api
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130503174941.043d10b7@nehalam.linuxnetplumber.net>
References: <20130503174941.043d10b7@nehalam.linuxnetplumber.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 05 May 2013 13:58:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Fri, 3 May 2013 17:49:41 -0700

> Programs using virtio headers outside of kernel will no longer
> build because u16 type does not exist in userspace. All user ABI
> must use __u16 typedef instead.
> 
> Bug introduce by:
>   commit 986a4f4d452dec004697f667439d27c3fda9c928
>   Author: Jason Wang <jasowang@redhat.com>
>   Date:   Fri Dec 7 07:04:56 2012 +0000
> 
>     virtio_net: multiqueue support
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied and queued up for -stable.
