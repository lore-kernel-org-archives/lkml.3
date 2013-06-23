Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3FWV1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:27:11 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:52879 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3FWV1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:27:10 -0400
MIME-Version: 1.0
In-Reply-To: <51C7615B.5010508@zytor.com>
References: <51C3DDFA.7050204@zytor.com>
	<51C69732.1010906@gmail.com>
	<b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com>
	<20130623192936.GA28655@khazad-dum.debian.net>
	<51C75465.9060007@zytor.com>
	<CAPM=9tzkJTf4d=HfBUs3VwmNG1+Zo5J-JURYd4mYcJ82yXZOKg@mail.gmail.com>
	<51C75CD6.5010206@zytor.com>
	<CAPM=9tyf18k+WYE7HwuJi2hefFYPyAYp6vVRvfgfprSYjapE-g@mail.gmail.com>
	<51C7615B.5010508@zytor.com>
Date: Mon, 24 Jun 2013 07:27:07 +1000
Message-ID: <CAPM=9txuwiZM3RdtmUg8duBQVep-amJ6HBDJ4w5VQj8-i02Ksg@mail.gmail.com>
Subject: Re: MTRR use in drivers
From: Dave Airlie <airlied@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Brice Goglin <brice.goglin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 6:58 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/23/2013 01:54 PM, Dave Airlie wrote:
>>>> breaking old boxes just because, is just going to get reverted when I
>>>> get the first regression report that you broke old boxes.
>>>>
>>>
>>> Not "just because", but *if* the choice is between breaking old boxes
>>> and breaking new boxes I'll take the latter.
>>>
>>
>> But Linus won't so your choice doesn't matter.
>
> I hate to break it to you, but we regress on ancient hardware all the
> time.  Optimization work gets done on modern machines, so the sweet spot
> keeps moving.  In particular, if supporting ancient hardware means
> leaving a lot of performance on modern hardware on the table, we may
> have to take that penalty.
>
> Fortunately, most of the time we don't have to.

Big difference between optimization sweet-spot and deliberately
breaking older systems. This is firmly in the second category, lots of
Intel hardware stops being useable when MTRR and PAT isn't working,
so much so we had to a warning to the driver when we detect such a thing.

Dave.
