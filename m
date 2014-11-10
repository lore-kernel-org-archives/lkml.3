Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaKJU3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:29:04 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34579 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaKJU3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:29:01 -0500
MIME-Version: 1.0
In-Reply-To: <20141110.142439.2292080248990157625.davem@davemloft.net>
References: <20141110205945.51af32a6@canb.auug.org.au>
	<546100AF.40201@infradead.org>
	<20141110.142439.2292080248990157625.davem@davemloft.net>
Date: Mon, 10 Nov 2014 12:29:00 -0800
Message-ID: <CA+mtBx-DdWvafMVjKzBW7rX=gFgKjPejyiALmBGLZwODTWQzpA@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 10 (net/ipv4/ip_tunnel.c)
From: Tom Herbert <therbert@google.com>
To: David Miller <davem@davemloft.net>
Cc: rdunlap@infradead.org, sfr@canb.auug.org.au,
        Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am looking at it.

On Mon, Nov 10, 2014 at 11:24 AM, David Miller <davem@davemloft.net> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> Date: Mon, 10 Nov 2014 10:15:11 -0800
>
>> On 11/10/14 01:59, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20141106:
>>>
>>
>> on x86_64:
>> when CONFIG_NET_IP_TUNNEL=y and CONFIG_NET_FOU=m:
>>
>> net/built-in.o: In function `ip_tunnel_encap':
>> (.text+0xb04d8): undefined reference to `gue_build_header'
>> net/built-in.o: In function `ip_tunnel_encap':
>> (.text+0xb04ea): undefined reference to `fou_build_header'
>
> Tom, this has now been reported twice, please fix this.
>
> Thanks.
