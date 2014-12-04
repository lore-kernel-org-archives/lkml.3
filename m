Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaLDPwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:52:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbaLDPwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:52:09 -0500
Message-ID: <5480830A.8090803@redhat.com>
Date: Thu, 04 Dec 2014 16:51:38 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Where exactly will arch_fast_hash be used
References: <20141204081147.GA19030@gondor.apana.org.au> <20141204152637.GA32140@casper.infradead.org> <20141204152929.GA22075@gondor.apana.org.au> <20141204153938.GC32140@casper.infradead.org> <54808123.8000704@redhat.com> <20141204154708.GA22185@gondor.apana.org.au>
In-Reply-To: <20141204154708.GA22185@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 04:47 PM, Herbert Xu wrote:
> On Thu, Dec 04, 2014 at 04:43:31PM +0100, Daniel Borkmann wrote:
>>
>> Hm, I thought the kernel doc on arch_fast_hash() in include/linux/hash.h
>> would give enough of a hint ...
>
> I think something more explicit like "do not use this in a hash
> table unless you know what you're doing" might be needed.

Ok, I'm fine with that, do you want to submit a patch on top of, or
after Hannes' improvements [1] got in? Thanks a lot, Herbert.

   [1] http://patchwork.ozlabs.org/patch/417761/
