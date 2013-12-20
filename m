Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030251Ab3LTN6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:58:10 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:42545 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030190Ab3LTN6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:58:08 -0500
Date: Fri, 20 Dec 2013 14:58:07 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: randconfig build error with next-20131220, in net/sctp/input.c
Message-ID: <20131220135807.GE32129@order.stressinduktion.org>
Mail-Followup-To: Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, vyasevich@gmail.com,
	nhorman@tuxdriver.com, "David S. Miller" <davem@davemloft.net>,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
References: <CA+r1ZhjYQoZJQLFO=t=mtV8g4CQD5HPU1NjCcYG_HGH=L=xiZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhjYQoZJQLFO=t=mtV8g4CQD5HPU1NjCcYG_HGH=L=xiZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 06:51:20AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> net/sctp/input.c: In function ‘sctp_icmp_frag_needed’:
> net/sctp/input.c:392:2: error: implicit declaration of function
> ‘ip6_sk_accept_pmtu’ [-Werror=implicit-function-declaration]
>   if (!ip6_sk_accept_pmtu(sk))
>   ^
> cc1: some warnings being treated as errors
> make[2]: *** [net/sctp/input.o] Error 1

Sorry, for that. I already proposed a patch:
<http://patchwork.ozlabs.org/patch/303308/>

Greetings,

  Hannes

