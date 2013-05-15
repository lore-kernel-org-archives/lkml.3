Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3EOGif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 02:38:35 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58990 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3EOGid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 02:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-+jBNTLrU5jRqj7LyxrQBWAE7GC634qYRJ4zDy2_LqgcA@mail.gmail.com>
References: <1360771110-9490-1-git-send-email-christian.gmeiner@gmail.com>
 <CAK5ve-K43n=4n1GyRW+2PgMTe2bU6ROHAa-_dK_0LgzM7JCRcw@mail.gmail.com>
 <CAH9NwWc+BP5ZbHwmMZ4AisviDHM-GizTmZO6vwxtd=ntYUAk=A@mail.gmail.com>
 <CAH9NwWceaA0MPGj65fOhmECL8A522qngU3RHGZ++Uz-6mVKKAg@mail.gmail.com>
 <CAK5ve-JmVes+OA3MRyoZEo_Fz8_RHpdqmcTxNwwrUAnADpqvyw@mail.gmail.com>
 <CAH9NwWeMMYzvE0VVMCYmF9oXA-wBiW-BnwoK1q7mjUkE4JF9uw@mail.gmail.com>
 <CAH9NwWfgMswKtdCNTOa5nbmd9uf6zg_jV7UD_h28bsq+PQcX=g@mail.gmail.com>
 <CAH9NwWe6seN+y29wm8KMn-2y+ePUjuzUULFNWpGLJ8Rn2H7P7A@mail.gmail.com>
 <CAK5ve-JqvOHQR+eSaq7HJ3rsaxj-kuhKw2skOa74+Sc=WqxTAQ@mail.gmail.com>
 <20130514101608.60c64b73.akpm@linux-foundation.org> <CAK5ve-+jBNTLrU5jRqj7LyxrQBWAE7GC634qYRJ4zDy2_LqgcA@mail.gmail.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 15 May 2013 08:38:11 +0200
Message-ID: <CAH9NwWfwVYitYw_+Ngnu1mU1-GgxF-SVtLyhq1xEXaGVyZoMXA@mail.gmail.com>
Subject: Re: [PATCH] leds-ot200: Fix misbehavior caused by wrong bit masks
To: Bryan Wu <cooloney@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/14 Bryan Wu <cooloney@gmail.com>:
> On Tue, May 14, 2013 at 10:16 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Tue, 14 May 2013 10:12:04 -0700 Bryan Wu <cooloney@gmail.com> wrote:
>>
>>> On Tue, May 14, 2013 at 12:06 AM, Christian Gmeiner
>>> <christian.gmeiner@gmail.com> wrote:
>>> > 2013/5/12 Christian Gmeiner <christian.gmeiner@gmail.com>:
>>> >> 2013/3/8 Christian Gmeiner <christian.gmeiner@gmail.com>:
>>> >>> 2013/3/5 Bryan Wu <cooloney@gmail.com>:
>>> >>>> On Sun, Mar 3, 2013 at 11:40 PM, Christian Gmeiner
>>> >>>> <christian.gmeiner@gmail.com> wrote:
>>> >>>>> ping
>>> >>>>> --
>>>
>>> I found this patch is still in linux-next, I'm not sure whether it
>>> will be merged into 3.10 like a bug fixing. We need to wait Andrew's
>>> reply. I'm OK to pick up and send out to Linus as a bug fixing.
>>
>> whome, I'd forgotten I had this.  I stuck a cc:stable on the end and
>> shall send it in to Linus in the next 3.10 batch, OK?
>>
>
> No problem for me at all. I bet it's OK for Christian as well, since
> merging into 3.10-rc1 has no difference with merging into 3.10-rc2 or
> later. It will eventually show up in 3.10 release.
>

I am fine with that... it would be great if the patch will show up in 3.10.

thanks
--
Christian Gmeiner, MSc
