Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3HGQkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:40:16 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:53792 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3HGQkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:40:13 -0400
Message-ID: <1375893609.4004.33.camel@edumazet-glaptop>
Subject: Re: linux-next: Tree for Aug 7
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Phil Sutter <phil@nwl.cc>, Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        wireless <linux-wireless@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>
Date: Wed, 07 Aug 2013 09:40:09 -0700
In-Reply-To: <1375892522.8154.3.camel@jlt4.sipsolutions.net>
References: <20130807155443.a0355d0429f3e0b4ccbed261@canb.auug.org.au>
	 <CA+icZUW+uxCsvPYcY2RRvMxRVzaBLuH9u8M4ziQNWXv=nk4b2w@mail.gmail.com>
	 <20130807155918.GA16263@orbit.nwl.cc>
	 <1375891974.8154.1.camel@jlt4.sipsolutions.net>
	 <1375892245.4004.31.camel@edumazet-glaptop>
	 (sfid-20130807_181729_176093_C3201A13) <1375892522.8154.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 18:22 +0200, Johannes Berg wrote:

> Maybe. I haven't tested it, but I'm thinking that skb->data doesn't
> point to the start of the data frame in this case, since we now call
> eth_type_trans() which pulls the ethernet header. So if the device just
> transmits skb->len starting from skb->data, it'll be wrong, no? That
> seems a basic assumption though.

Yes, it seems calling eth_type_trans() is not right here, and even could
crash.

Sorry, for being vague, I am a bit busy this morning.




