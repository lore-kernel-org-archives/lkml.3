Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3K2IuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:50:23 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752616Ab3K2IuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:50:20 -0500
From: Richard Weinberger <richard@nod.at>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Shawn Landden <shawn@churchofgit.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Herbert <therbert@google.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [PATCH] update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST
Date: Fri, 29 Nov 2013 09:50:11 +0100
Message-ID: <5125331.5M593Q7tBS@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131129054704.GI24171@order.stressinduktion.org>
References: <20131125042633.GA4156@order.stressinduktion.org> <1385361388-2175-1-git-send-email-shawn@churchofgit.com> <20131129054704.GI24171@order.stressinduktion.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn,

Am Freitag, 29. November 2013, 06:47:04 schrieb Hannes Frederic Sowa:
> On Sun, Nov 24, 2013 at 10:36:28PM -0800, Shawn Landden wrote:
> > Commit 35f9c09fe (tcp: tcp_sendpages() should call tcp_push() once)
> > added an internal flag MSG_SENDPAGE_NOTLAST, similar to
> > MSG_MORE.
> > 
> > algif_hash, algif_skcipher, and udp used MSG_MORE from tcp_sendpages()
> > and need to see the new flag as identical to MSG_MORE.
> > 
> > This fixes sendfile() on AF_ALG.
> > 
> > v3: also fix udp
> 
> The UDP bits look fine to me.

please don't forget to resend the patch (only the UDP fix).
I sent the AF_ALG part already.

Thanks,
//richard
