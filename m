Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab3FFI6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:58:05 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:59844 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3FFI6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:58:01 -0400
Message-ID: <51B04F0F.6070307@bootc.net>
Date: Thu, 06 Jun 2013 09:57:51 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130520 Icedove/17.0.5
MIME-Version: 1.0
To: Timo Teras <timo.teras@iki.fi>
CC: Fan Du <fan.du@windriver.com>, Jean Sacren <sakiwit@gmail.com>,
        steffen.klassert@secunet.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PANIC at net/xfrm/xfrm_output.c:125 (3.9.4)
References: <51AFB204.8070009@bootc.net> <20130606010416.GF26681@mail.gmail.com> <51AFE4C2.1000604@windriver.com> <51B03EAC.6080508@bootc.net> <20130606113840.511a72c3@vostro>
In-Reply-To: <20130606113840.511a72c3@vostro>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/13 09:38, Timo Teras wrote:
> On Thu, 06 Jun 2013 08:47:56 +0100
> Chris Boot <bootc@bootc.net> wrote:
> 
>> On 06/06/13 02:24, Fan Du wrote:
>>> Hello Chris/Jean
>>>
>>> This issue might have already been fixed by this:
>>> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/net/xfrm/xfrm_output.c?id=497574c72c9922cf20c12aed15313c389f722fa0
>>>
>>>
>>> Hope it helps.
>>
>> Hi Fan, Jean,
>>
>> Thanks, that looks like it's the patch for exactly my problem.
>> Unfortunately I can't test it until next week now. :-/
>>
>> Timo/Dave: are there any plans to push this into 3.10-rc and/or
>> stable? I seem to be able to hit the issue pretty reliably.
> 
> It is already present in 3.10-rc3 [1], and Dave has it queued for
> 3.9-stable [2].
> 
> - Timo
> 
> [1] http://lwn.net/Articles/551922/
> [2] http://patchwork.ozlabs.org/patch/245594/

Thank you!

Cheers,
Cheers

-- 
Chris Boot
bootc@bootc.net
