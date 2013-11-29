Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3K2FrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 00:47:09 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:45848 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3K2FrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 00:47:06 -0500
Date: Fri, 29 Nov 2013 06:47:04 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Shawn Landden <shawn@churchofgit.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        richard.weinberger@gmail.com
Subject: Re: [PATCH] update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST
Message-ID: <20131129054704.GI24171@order.stressinduktion.org>
Mail-Followup-To: Shawn Landden <shawn@churchofgit.com>,
	Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Herbert <therbert@google.com>,
	"David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
	richard.weinberger@gmail.com
References: <20131125042633.GA4156@order.stressinduktion.org> <1385361388-2175-1-git-send-email-shawn@churchofgit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385361388-2175-1-git-send-email-shawn@churchofgit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 10:36:28PM -0800, Shawn Landden wrote:
> Commit 35f9c09fe (tcp: tcp_sendpages() should call tcp_push() once)
> added an internal flag MSG_SENDPAGE_NOTLAST, similar to
> MSG_MORE.
> 
> algif_hash, algif_skcipher, and udp used MSG_MORE from tcp_sendpages()
> and need to see the new flag as identical to MSG_MORE.
> 
> This fixes sendfile() on AF_ALG.
> 
> v3: also fix udp

The UDP bits look fine to me.

Greetings,

  Hannes

