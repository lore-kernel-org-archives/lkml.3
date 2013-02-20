Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab3BTWOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:14:49 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58675 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3BTWOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:14:48 -0500
Message-ID: <51254AD2.7000906@suse.cz>
Date: Wed, 20 Feb 2013 23:14:42 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>,
        Daniel J Blueman <daniel@numascale-asia.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: kswapd craziness round 2
References: <5121C7AF.2090803@numascale-asia.com> <CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com>
In-Reply-To: <CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 12:42 PM, Hillf Danton wrote:
> On Mon, Feb 18, 2013 at 2:18 PM, Daniel J Blueman
> <daniel@numascale-asia.com> wrote:
>> On Monday, 18 February 2013 06:10:02 UTC+8, Jiri Slaby  wrote:
>>
>>> Hi,
>>>
>>> You still feel the sour taste of the "kswapd craziness in v3.7" thread,
>>> right? Welcome to the hell, part two :{.
...
>>> kswap is working very toughly though:
>>> root       580  0.6  0.0      0     0 ?        S    úno12  46:21 [kswapd0]
...
>> [ 2675.587878] INFO: rcu_sched self-detected stall on CPU { 5}  (t=24000
>> jiffies g=6313 c=6312 q=68)
> 
> Does Ingo's revert help? https://lkml.org/lkml/2013/2/15/168

Not at all...


-- 
js
suse labs
