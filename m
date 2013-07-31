Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab3GaLI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:08:27 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37143 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3GaLI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:08:26 -0400
Date: Wed, 31 Jul 2013 13:08:21 +0200
From: Christoph Paasch <christoph.paasch@gmail.com>
To: Dmitry Popov <dp@highloadlab.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] tcp: Remove unused tcpct declarations and comments
Message-ID: <20130731110821.GA3747@cpaasch-mac>
References: <20130731133945.5b7b3f7487491f41ea45a7f6@highloadlab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731133945.5b7b3f7487491f41ea45a7f6@highloadlab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/13 - 13:39:45, Dmitry Popov wrote:
> Remove declaration, 4 defines and confusing comment that are no longer used
> since 1a2c6181c4 ("tcp: Remove TCPCT").
> 
> Signed-off-by: Dmitry Popov <dp@highloadlab.com>
> ---
>  include/linux/tcp.h | 1 -
>  include/net/tcp.h   | 4 ----
>  net/ipv4/tcp.c      | 4 ----
>  3 files changed, 9 deletions(-)

Sorry, I oversaw these when removing TCPCT.

Acked-by: Christoph Paasch <christoph.paasch@uclouvain.be>

