Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab3EGJMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:12:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759198Ab3EGJMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:12:40 -0400
Message-ID: <5188C578.4030907@redhat.com>
Date: Tue, 07 May 2013 11:12:24 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Liu Ying <liu.y.victor@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, davem@davemloft.net,
        tglx@linutronix.de, john.stultz@linaro.org,
        Liu Ying <Ying.Liu@freescale.com>
Subject: Re: [PATCH 1/1] ktime: Use macro NSEC_PER_USEC instead of a magic
 number
References: <5188B809.5060803@redhat.com> <CA+8Hj83_6Feq8KVSJh+E=R35wm2ZkF+uGWxcJV7XZsOxdze41A@mail.gmail.com> <CA+8Hj838CfaAKjdLtO2zdZ5DJP10a0QCzhYJbZ3GqQhmE5MZzw@mail.gmail.com>
In-Reply-To: <CA+8Hj838CfaAKjdLtO2zdZ5DJP10a0QCzhYJbZ3GqQhmE5MZzw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 11:08 AM, Liu Ying wrote:
> 2013/5/7 Liu Ying <liu.y.victor@gmail.com>
>> 2013/5/7 Daniel Borkmann <dborkman@redhat.com>
>>> On 05/06/2013 02:42 PM, y@shlinux1.ap.freescale.net wrote:
>>>> From: Liu Ying <Ying.Liu@freescale.com>

>>> If you only have 1 patch, then you don't need "1/1" in the subject.
>>> The term magic number here might be a little exaggerated, not so
>>> magic actually. :-)
>>>
>> Thanks. I will update this. How about turning "magic number" to "immediate
>> number"?

Maybe like ``ktime: Use macro NSEC_PER_USEC where appropriate''.
