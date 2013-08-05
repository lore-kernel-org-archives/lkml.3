Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3HESD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:03:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47447 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3HESDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:03:25 -0400
Date: Mon, 05 Aug 2013 11:03:21 -0700 (PDT)
Message-Id: <20130805.110321.179491711331112454.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, john.r.fastabend@intel.com, kaber@trash.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] macvlan: validate flags
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130805152554.GA3592@redhat.com>
References: <20130805152554.GA3592@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 05 Aug 2013 11:03:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 5 Aug 2013 18:25:54 +0300

> commit df8ef8f3aaa6692970a436204c4429210addb23a
>     macvlan: add FDB bridge ops and macvlan flags
> added a flags field to macvlan, which can be
> controlled from userspace.
> The idea is to make the interface future-proof
> so we can add flags and not new fields.
> 
> However, flags value isn't validated, as a result,
> userspace can't detect which flags are supported.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: John Fastabend <john.r.fastabend@intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied and queued up for -stable, thanks.
