Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab3FWU6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 16:58:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42930 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab3FWU6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 16:58:18 -0400
Message-ID: <51C7615B.5010508@zytor.com>
Date: Sun, 23 Jun 2013 13:58:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: MTRR use in drivers
References: <51C3DDFA.7050204@zytor.com> <51C69732.1010906@gmail.com> <b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com> <20130623192936.GA28655@khazad-dum.debian.net> <51C75465.9060007@zytor.com> <CAPM=9tzkJTf4d=HfBUs3VwmNG1+Zo5J-JURYd4mYcJ82yXZOKg@mail.gmail.com> <51C75CD6.5010206@zytor.com> <CAPM=9tyf18k+WYE7HwuJi2hefFYPyAYp6vVRvfgfprSYjapE-g@mail.gmail.com>
In-Reply-To: <CAPM=9tyf18k+WYE7HwuJi2hefFYPyAYp6vVRvfgfprSYjapE-g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 01:54 PM, Dave Airlie wrote:
>>> breaking old boxes just because, is just going to get reverted when I
>>> get the first regression report that you broke old boxes.
>>>
>>
>> Not "just because", but *if* the choice is between breaking old boxes
>> and breaking new boxes I'll take the latter.
>>
> 
> But Linus won't so your choice doesn't matter.

I hate to break it to you, but we regress on ancient hardware all the
time.  Optimization work gets done on modern machines, so the sweet spot
keeps moving.  In particular, if supporting ancient hardware means
leaving a lot of performance on modern hardware on the table, we may
have to take that penalty.

Fortunately, most of the time we don't have to.

	-hpa



