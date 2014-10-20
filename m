Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaJTBDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 21:03:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56987 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaJTBDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 21:03:16 -0400
Date: Sun, 19 Oct 2014 21:03:14 -0400 (EDT)
Message-Id: <20141019.210314.1388340101577924200.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: pablo@netfilter.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFz4UdVbZKPKwkesj0=1Yu7jLDP3Q3-jwe45b7gRU+0rog@mail.gmail.com>
References: <20141019.132314.264021750039480460.davem@davemloft.net>
	<CA+55aFz4UdVbZKPKwkesj0=1Yu7jLDP3Q3-jwe45b7gRU+0rog@mail.gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Oct 2014 18:03:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Oct 2014 17:32:15 -0700

> Looks like the module license issue was just overlooked when moving
> the code out in commit c8d7b98bec43 ("netfilter: move nf_send_resetX()
> code to nf_reject_ipvX modules").

I think Pablo has a patch pending to address this, and indeed he does:

	http://marc.info/?l=linux-netdev&m=141293491712312&w=2

Pablo please push this to me soon, thanks.
