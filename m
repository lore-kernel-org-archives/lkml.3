Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3FWUyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 16:54:10 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:41373 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FWUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 16:54:08 -0400
MIME-Version: 1.0
In-Reply-To: <51C75CD6.5010206@zytor.com>
References: <51C3DDFA.7050204@zytor.com>
	<51C69732.1010906@gmail.com>
	<b8bfa877-5663-4a93-94b4-6ea313e4d563@email.android.com>
	<20130623192936.GA28655@khazad-dum.debian.net>
	<51C75465.9060007@zytor.com>
	<CAPM=9tzkJTf4d=HfBUs3VwmNG1+Zo5J-JURYd4mYcJ82yXZOKg@mail.gmail.com>
	<51C75CD6.5010206@zytor.com>
Date: Mon, 24 Jun 2013 06:54:07 +1000
Message-ID: <CAPM=9tyf18k+WYE7HwuJi2hefFYPyAYp6vVRvfgfprSYjapE-g@mail.gmail.com>
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

>> breaking old boxes just because, is just going to get reverted when I
>> get the first regression report that you broke old boxes.
>>
>
> Not "just because", but *if* the choice is between breaking old boxes
> and breaking new boxes I'll take the latter.
>

But Linus won't so your choice doesn't matter.

>> Andy Lutomirski just submitted a bunch of patches to clean up the DRM
>> usage of mtrrs, they are in drm-next, afaik we no longer add them on
>> PAT systems.
>
> Fantastic news.  No issue, then, and no need to break anything.

Granted I haven't tested Andy's patches on my AGP boxes, and I intend to,
if they do cause any regressions he'll be working them out :-)

Dave.
