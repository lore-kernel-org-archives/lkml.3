Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3CDHkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:40:40 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33653 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3CDHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:40:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9NwWc+BP5ZbHwmMZ4AisviDHM-GizTmZO6vwxtd=ntYUAk=A@mail.gmail.com>
References: <1360771110-9490-1-git-send-email-christian.gmeiner@gmail.com>
 <CAK5ve-K43n=4n1GyRW+2PgMTe2bU6ROHAa-_dK_0LgzM7JCRcw@mail.gmail.com> <CAH9NwWc+BP5ZbHwmMZ4AisviDHM-GizTmZO6vwxtd=ntYUAk=A@mail.gmail.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 4 Mar 2013 08:40:17 +0100
Message-ID: <CAH9NwWceaA0MPGj65fOhmECL8A522qngU3RHGZ++Uz-6mVKKAg@mail.gmail.com>
Subject: Re: [PATCH] leds-ot200: Fix misbehavior caused by wrong bit masks
To: Bryan Wu <cooloney@gmail.com>
Cc: akpm <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping
--
Christian Gmeiner, MSc


2013/2/23 Christian Gmeiner <christian.gmeiner@gmail.com>:
> 2013/2/15 Bryan Wu <cooloney@gmail.com>:
>> On Wed, Feb 13, 2013 at 7:58 AM, Christian Gmeiner
>> <christian.gmeiner@gmail.com> wrote:
>>> During the development of this driver an in-house register
>>> documentation was used. The last weeks some integration tests
>>> were done and this problem was found. It turned out that
>>> the released register documentation is wrong.
>>>
>>> The fix is very simple: shift all masks by one.
>>>
>>> Our customers can control LEDs from userspace via Java,
>>> C++ or what every. They have running/working applications where
>>> they want to control led_3 but led_2 get's used.
>>> I got a bug report in our in-house bug tracker so it would be
>>> great to fix this upstream.
>>>
>>> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
>>
>> Thanks, Christian.
>>
>> And Andrew, are you going to take care of this patch? Or I will merge this.
>>
>
> Whats the current state of the patch? Hope we can get it into 3.9 :)
>
> --
> Christian Gmeiner, MSc
