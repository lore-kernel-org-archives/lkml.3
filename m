Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab3HGQR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:17:29 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56206 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab3HGQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:17:27 -0400
Message-ID: <1375892245.4004.31.camel@edumazet-glaptop>
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
Date: Wed, 07 Aug 2013 09:17:25 -0700
In-Reply-To: <1375891974.8154.1.camel@jlt4.sipsolutions.net>
References: <20130807155443.a0355d0429f3e0b4ccbed261@canb.auug.org.au>
	 <CA+icZUW+uxCsvPYcY2RRvMxRVzaBLuH9u8M4ziQNWXv=nk4b2w@mail.gmail.com>
	 <20130807155918.GA16263@orbit.nwl.cc>
	 <1375891974.8154.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 18:12 +0200, Johannes Berg wrote:
> On Wed, 2013-08-07 at 17:59 +0200, Phil Sutter wrote:
> 
> > The idea behind this patch is that users setting the protocol to
> > something else probably do know better and so should be left alone.
> 
> Regardless of that, I think that still the skb pointers would be changed
> by this patch which would confuse the receiver of the SKB (device
> driver), no? Has anyone verified that theory? :)

Maybe receivers made wrong assumptions about some headers being set or
not set ?

A patch can uncover prior bugs.

commit 76fe45812a3b134c3917 is an example of a fix we had to do because
of another fix ;)



