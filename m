Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaA2CFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:05:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48103 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaA2CFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:05:45 -0500
Date: Tue, 28 Jan 2014 18:05:44 -0800 (PST)
Message-Id: <20140128.180544.1357966891418521200.davem@davemloft.net>
To: dhowells@redhat.com
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        tim@electronghost.co.uk, khoroshilov@ispras.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AF_RXRPC fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <8672.1390928856@warthog.procyon.org.uk>
References: <8672.1390928856@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 28 Jan 2014 17:07:36 +0000

> Here are some small AF_RXRPC fixes.
> 
>  (1) Fix a place where a spinlock is taken conditionally but is released
>      unconditionally.
> 
>  (2) Fix a double-free that happens when cleaning up on a checksum error.
> 
>  (3) Fix handling of CHECKSUM_PARTIAL whilst delivering messages to userspace.

Pulled, thanks David.
