Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3LQUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:16:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab3LQUQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:16:57 -0500
Date: Tue, 17 Dec 2013 15:16:56 -0500 (EST)
Message-Id: <20131217.151656.2218064732946772466.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: dhowells@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RXRPC]: do not unlock unheld spinlock in
 rxrpc_connect_exclusive()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386975369-30837-1-git-send-email-khoroshilov@ispras.ru>
References: <1386975369-30837-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 17 Dec 2013 12:16:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Sat, 14 Dec 2013 02:56:09 +0400

> +		_net("CONNECT EXCL old %d on TRANS %d",
> +		     conn->debug_id, conn->trans->debug_id);

Please do not add more of these ad-hoc kernel log tracing entries.

Thanks.
