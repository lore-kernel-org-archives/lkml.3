Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab3KRKdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:33:31 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5858 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3KRKdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:33:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Nov 2013 02:27:29 -0800
Message-ID: <5289ECEE.4070505@nvidia.com>
Date: Mon, 18 Nov 2013 19:33:18 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH v2] Documentation: gpiolib: document new interface
References: <1384605261-8682-1-git-send-email-acourbot@nvidia.com> <CACRpkdZc0DWHe6AmawYp=SY=5==SUuJUHDETUTDw-6PbhR3tUg@mail.gmail.com>
In-Reply-To: <CACRpkdZc0DWHe6AmawYp=SY=5==SUuJUHDETUTDw-6PbhR3tUg@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 06:34 PM, Linus Walleij wrote:
> On Sat, Nov 16, 2013 at 1:34 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
>> The first version received zero feedback, hopefully this one will get more
>> attention. :) Not much changes, just some more proofreading and the fixes
>> and improvements that came from it. It looks ok as far as I am concerned.
>
> Sorry I was swamped with other stuff...
>
>> Linus, I hope this can be merged during the -rc cycle of 3.13, since the
>> gpiod_ interface is going to be introduced there. It would not make much
>> sense for it to come without its documentation.
>
> You're right of course. I'll read through it and apply fixes on top
> (or squash into your patch.)

Great, thanks!

> Formal stuff:
> Don't we need an 00-INDEX file?
> (Maybe Rob can tell whether this is desirable.)

Good idea. gpio.txt somehow fulfills that role, but it might be better 
if we split it. Would you like me to submit a new revision?

> I don't like double spaces after periods. I will just go and remove
> all of them from the new documentation unless you convince me
> otherwise. Reference:
> https://en.wikipedia.org/wiki/Sentence_spacing

Please do - actually I started doing it (they come from the old 
documentation, not the bits I have written myself) but have obviously 
missed at least a few of them. :)

Thanks,
Alex.

