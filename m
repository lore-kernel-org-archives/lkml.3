Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab3BSFx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:53:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54294 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3BSFx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:53:58 -0500
Date: Tue, 19 Feb 2013 00:53:56 -0500 (EST)
Message-Id: <20130219.005356.2288460992654639558.davem@davemloft.net>
To: drjones@redhat.com
Cc: xen-devel@lists.xensource.com, ian.campbell@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: netback: remove redundant xenvif_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361219360-29176-1-git-send-email-drjones@redhat.com>
References: <1361219360-29176-1-git-send-email-drjones@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Feb 2013 21:54:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>
Date: Mon, 18 Feb 2013 21:29:20 +0100

> netbk_fatal_tx_err() calls xenvif_carrier_off(), which does
> a xenvif_put(). As callers of netbk_fatal_tx_err should only
> have one reference to the vif at this time, then the xenvif_put
> in netbk_fatal_tx_err is one too many.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Applied.
