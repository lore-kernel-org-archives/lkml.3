Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaF2TGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 15:06:39 -0400
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:58246 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaF2TGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 15:06:38 -0400
Message-ID: <53B063BC.4040200@linicks.net>
Date: Sun, 29 Jun 2014 20:06:36 +0100
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
References: <53AE9058.50902@linicks.net> <20140628101240.GA6357@pd.tnic> <53AE9863.6050102@linicks.net> <53AE9F0B.1080207@linicks.net> <20140628122322.GC4373@pd.tnic> <53AEBE75.9070301@linicks.net>
In-Reply-To: <53AEBE75.9070301@linicks.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/14 14:09, Nick Warne wrote:
>
>
> On 28/06/14 13:23, Borislav Petkov wrote:
>> On Sat, Jun 28, 2014 at 11:55:07AM +0100, Nick Warne wrote:
>>> Whoops - that is WRONG (too many ssh terminals)
>>>
>>> gcc version 4.2.4
>>
>> That's some old compiler. Anyway, I can't trigger it here with gcc 4.6
>> and 4.9.
>>
>> Can you do
>>
>> $ make clean
>> $ make V=1 fs/mbcache.i >>w.log 2>&1
>> $ make V=1 fs/mbcache.s >>w.log 2>&1
>>
>> and zip and send me fs/mbcache.i, fs/mbcache.s and w.log.
>
> OK, fs/mbcache.s didn't appear.
>
> logs attached.

OK, I just spent three months building GCC 4.7.4 today (thank god the 
world cup is on to watch instead) and 3.15.2 built fine, and server is 
up and running great.

This then is an old(er) version of GCC issue (but I dunno what).

Sorry for the noise and thanks.

Nick
-- 
"A bug in the code is worth two in the documentation."
FSF Associate Member 5508
http://linicks.net/
http://pi.linicks.net/
