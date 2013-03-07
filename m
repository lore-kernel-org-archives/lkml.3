Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853Ab3CGVZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:25:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46292 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563Ab3CGVZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:25:18 -0500
Date: Thu, 07 Mar 2013 16:25:16 -0500 (EST)
Message-Id: <20130307.162516.39680676875980781.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost_net: remove tx polling state
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362630716-57674-1-git-send-email-jasowang@redhat.com>
References: <1362630716-57674-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 07 Mar 2013 13:25:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu,  7 Mar 2013 12:31:56 +0800

> After commit 2b8b328b61c799957a456a5a8dab8cc7dea68575 (vhost_net: handle polling
> errors when setting backend), we in fact track the polling state through
> poll->wqh, so there's no need to duplicate the work with an extra
> vhost_net_polling_state. So this patch removes this and make the code simpler.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Can I get an ACK or two from some VHOST folks?
