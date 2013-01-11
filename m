Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3AKOwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:52:36 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50700 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab3AKOwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <87pq1c1uj4.fsf@rustcorp.com.au>
References: <871ug75vp1.fsf@rustcorp.com.au>
	<1354718230-4486-1-git-send-email-sjur@brendeland.net>
	<20121206102750.GF10837@redhat.com>
	<877goc0wac.fsf@rustcorp.com.au>
	<CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com>
	<87pq1f2rj0.fsf@rustcorp.com.au>
	<87wqvl1g9s.fsf@rustcorp.com.au>
	<CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com>
	<87pq1c1uj4.fsf@rustcorp.com.au>
Date: Fri, 11 Jan 2013 15:52:34 +0100
Message-ID: <CAJK669b9D_NNhtg=nE+beM9xaqQbrbD3wJqqhCCG62WavdqpSg@mail.gmail.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 12:35 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Hi Sjur!
>
>         OK, the Internet was no help here, how do you pronounce Sjur?
> I'm guessing "shoor" rhyming with tour until I know better.

Thank you for asking! This is pretty close yes.
I usually tell people to pronounce it like "sure" for simplicity.
But Google translate has a perfect Norwegian voice pronouncing my name:
http://translate.google.com/#auto/no/sjur (Press the speaker button)

While at the subject: Norwegian names can be a laugh: I have people
named "Odd" and "Even" in my family, and I once had a friend named
"Aashold".

...

>> I would prefer not to split into pages at this point, but rather provide an
>> iterator or the original list found in the descriptor to the client.
...
> In other words, boundaries matter?
>
> While the sg-in-place hack is close to optimal for TCM_VHOST, neither
> net not you can use it directly.  I'll switch to an iovec (with a
> similar use-caller-supplied-if-it-fits trick); they're smaller anyway.

Great, I think iovec will be a good fit for my CAIF driver.

Thanks,
Sjur
