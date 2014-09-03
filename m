Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaICQx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:53:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:41154 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaICQx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:53:26 -0400
Message-ID: <54074781.50909@infradead.org>
Date: Wed, 03 Sep 2014 09:53:21 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org
CC: trivial@kernel.org
Subject: Re: [PATCH] net: treewide: Fix typo found in DocBook/networking.xml
References: <1409716755-1994-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1409716755-1994-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/14 20:59, Masanari Iida wrote:
> This patch fix spelling typo found in DocBook/networking.xml.
> It is because the neworking.xml is generated from comments
> in the source, I have to fix typo in comments within the source.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  include/linux/netdevice.h  | 4 ++--
>  include/net/wimax.h        | 2 +-
>  include/trace/events/irq.h | 4 ++--
>  net/core/datagram.c        | 2 +-
>  net/core/gen_estimator.c   | 2 +-
>  net/core/gen_stats.c       | 2 +-
>  net/core/skbuff.c          | 4 ++--
>  net/core/sock.c            | 4 ++--
>  net/socket.c               | 2 +-
>  9 files changed, 13 insertions(+), 13 deletions(-)


-- 
~Randy
