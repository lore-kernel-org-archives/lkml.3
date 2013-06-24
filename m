Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3FXHBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:01:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37390 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3FXHB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:01:28 -0400
Date: Mon, 24 Jun 2013 00:01:27 -0700 (PDT)
Message-Id: <20130624.000127.3603241221368993.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, asias@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] vhost-net: fix use-after-free in vhost_net_flush
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130620114813.GA17373@redhat.com>
References: <20130620114813.GA17373@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 20 Jun 2013 14:48:13 +0300

> vhost_net_ubuf_put_and_wait has a confusing name:
> it will actually also free it's argument.
> Thus since commit 1280c27f8e29acf4af2da914e80ec27c3dbd5c01

Never reference commits only by SHA1 ID, it is never sufficient.

Always provide, after the SHA1 ID, in parenthesis, the header line
from the commit message.

To be honest, I'm kind of tired of telling people they need to do
this over and over again.

Maybe people keep forgetting because the reason why this is an issue
hasn't really sunk in.

If the patch you reference got backported into another tree, it will
not have the SHA1 ID, and therefore someone reading the "fix" won't
be able to find the fault causing change without going through a lot
of trouble.  By providing the commit header line you remove that
problem altogether, no ambiguity is possible.
