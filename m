Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaEAVU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:20:59 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51040 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaEAVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:20:58 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5362BAB5.7060703@roeck-us.net>
Date: Thu, 01 May 2014 14:20:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 2/2] Hexagon: Delete stale barrier.h
References: <1397808515-8013-1-git-send-email-vgupta@synopsys.com>	<1397808515-8013-3-git-send-email-vgupta@synopsys.com>	<20140501161005.GA6212@roeck-us.net> <CA+55aFwCOW+bZHfAYMJsFQqEiX7bE79B-JwcJxZ67UVtEQgpcA@mail.gmail.com>
In-Reply-To: <CA+55aFwCOW+bZHfAYMJsFQqEiX7bE79B-JwcJxZ67UVtEQgpcA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 10:10 AM, Linus Torvalds wrote:
> On Thu, May 1, 2014 at 9:10 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Hexagon build is still broken with 3.15-rc3 and with the latest upstream.
>> This patch fixes the (build) problem. Would be great if the arch maintainer
>> could apply this (or a similar) patch and send it to Linus.
>
> I took it directly, since you compile-tested it.
>

Great, thanks!

Guenter


