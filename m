Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3EaBLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 21:11:34 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:2271 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3EaBLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 21:11:31 -0400
Message-ID: <1369962688.1751.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] net: skbuff: use _RET_IP_
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 30 May 2013 18:11:28 -0700
In-Reply-To: <87obbsohd1.fsf@nemi.mork.no>
References: <1369861743.4188.33.camel@buesod1.americas.hpqcorp.net>
	 <51A6768B.5050603@cogentembedded.com> <87obbsohd1.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 13:08 +0200, Bjørn Mork wrote:
> Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> writes:
> 
> >     Why not "text:%#lx" as already used in this string? It's
> > equivalent to "0x%lx".
> 
> Well, I don't know the reasoning in this case, but I'd like to note that
> those are not strictly equivalent.  Personally I find the formatting of 0
> annoying enough to avoid %#x for any value which may be 0.  It's
> especially bad if you try to line up things by adding leading zeros.

Yep, I found that 0x%lx produced the same output as %p. If you'd rather
I use something else instead, I'm happy to update the patch.

Thanks,
Davidlohr

