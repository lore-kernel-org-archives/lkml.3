Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3EaHGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:06:53 -0400
Received: from canardo.mork.no ([148.122.252.1]:42911 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab3EaHGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:06:46 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Joe Perches <joe@perches.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: skbuff: use _RET_IP_
Organization: m
References: <1369861743.4188.33.camel@buesod1.americas.hpqcorp.net>
	<51A6768B.5050603@cogentembedded.com> <87obbsohd1.fsf@nemi.mork.no>
	<1369962688.1751.6.camel@buesod1.americas.hpqcorp.net>
	<1369977659.10556.34.camel@joe-AO722>
Date: Fri, 31 May 2013 09:06:06 +0200
In-Reply-To: <1369977659.10556.34.camel@joe-AO722> (Joe Perches's message of
	"Thu, 30 May 2013 22:20:59 -0700")
Message-ID: <87obbrljc1.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> On Thu, 2013-05-30 at 18:11 -0700, Davidlohr Bueso wrote:
>> On Thu, 2013-05-30 at 13:08 +0200, Bjørn Mork wrote:
>> > Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> writes:
>> > 
>> > >     Why not "text:%#lx" as already used in this string? It's
>> > > equivalent to "0x%lx".
>> > 
>> > Well, I don't know the reasoning in this case, but I'd like to note that
>> > those are not strictly equivalent.  Personally I find the formatting of 0
>> > annoying enough to avoid %#x for any value which may be 0.  It's
>> > especially bad if you try to line up things by adding leading zeros.
>> 
>> Yep, I found that 0x%lx produced the same output as %p.
>
> Don't use a standalone gcc compiled program to
> determine what the kernel outputs.

That's a very good point.  Sorry for mixing this up.  You are of course
right.  The kernel does everything correctly, so there is no reason not
to use %#x



Bjørn
