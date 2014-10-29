Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbaJ2OXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:23:18 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:50948 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbaJ2OXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <20141028173853.GD18557@sirena.org.uk>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
	<20141027193229.GE18557@sirena.org.uk>
	<CAMo8Bf+Z9V8mkiC3JOupPQmi1EJUDKrb1qcNncDbsEbhjigbww@mail.gmail.com>
	<20141028154224.GX18557@sirena.org.uk>
	<CAMo8BfLpJ0bdmaFt9+gLQ_kEjB68XdjAJUw8f8s=Owv46h_yDQ@mail.gmail.com>
	<20141028173853.GD18557@sirena.org.uk>
Date: Wed, 29 Oct 2014 17:23:15 +0300
Message-ID: <CAMo8BfJfRTo7puxeafyBnaGWhY38o6ktsSBugcSmSaMYUArcyw@mail.gmail.com>
Subject: Re: [PATCH] ASoC: add xtensa xtfpga I2S interface and platform
From: Max Filippov <jcmvbkbc@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 8:38 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Oct 28, 2014 at 08:00:45PM +0300, Max Filippov wrote:
>> On Tue, Oct 28, 2014 at 6:42 PM, Mark Brown <broonie@kernel.org> wrote:
>> >> > I would also expect to see the data transfer and I2S bits more split
>> >> > out, presumably this IP can actually be used in designs with a DMA
>> >> > controller and one would expect that for practical systems this would be
>> >> > the common case?
>
>> >> I don't know of other designs that use this IP block. Can we do it when
>> >> we get such users?
>
>> > It's also about ensuring that the code is cleanly split up so that
>> > someone can actually go in and add the required support later (and TBH
>
>> Can you point me to an example of such split, so that I don't write it in
>> an unusual way?
>
> Essentially all drivers are split this way...

But all of them have DMA registers and I2S registers completely separated,
right? How do I share registers between pcm and i2s parts?

-- 
Thanks.
-- Max
