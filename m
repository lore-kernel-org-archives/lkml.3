Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935312Ab3DPBTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:19:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40368 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934799Ab3DPBTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:19:49 -0400
X-Spam-Score: -100.8
Message-ID: <516CA70B.2080605@asianux.com>
Date: Tue, 16 Apr 2013 09:19:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3]  kernel: kallsyms: memory override issue, need check
 destination buffer length
References: <51662AC7.1090004@asianux.com> <87eheh4sls.fsf@rustcorp.com.au> <51664B04.7000207@asianux.com> <87y5ck8s5x.fsf@rustcorp.com.au> <516B867A.1080000@asianux.com> <877gk48hui.fsf@rustcorp.com.au>
In-Reply-To: <877gk48hui.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013Äê04ÔÂ15ÈÕ 13:48, Rusty Russell wrote:
> Chen Gang <gang.chen@asianux.com> writes:
> 
>> >   We don't export any symbols > 128 characters, but if we did then
>> >   kallsyms_expand_symbol() would overflow the buffer handed to it.
>> >   So we need check destination buffer length when copying.
>> >
>> >   the related test:
>> >     if we define an EXPORT function which name more than 128.
>> >     will panic when call kallsyms_lookup_name by init_kprobes on booting.
>> >     after check the length (provide this patch), it is ok.
>> >
>> >   Implementaion:
>> >     add additional destination buffer length parameter (maxlen)
>> >     if uncompressed string is too long (>= maxlen), it will be truncated.
>> >     not check the parameters whether valid, since it is a static function.
> Thanks, applied.
> 
> I've put this in my modules-next branch.
> 

  thank you very much to spend time resources for it.

  and next, I should be careful to send patch. so do not wast other
members' time resources for my careless mistakes.

  the details are:
    a. if modify code, need always compile again, at least.
    b. reduce reply times, so can reduce some of my waste information.

  I will let additional machine (a PC) for test and compile instead of
my current work machine, so when I have to do another things (normally,
it is), the individual machine can continue compiling or testing.

  thanks again.

  :-)

> Cheers,
> Rusty.
> 
> 

-- 
Chen Gang

Asianux Corporation
