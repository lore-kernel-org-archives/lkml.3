Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab3GZTCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:02:54 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64564 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3GZTCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130726185609.GY9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
	<1374863133-6745-5-git-send-email-eu@felipetonello.com>
	<20130726185609.GY9858@sirena.org.uk>
Date: Fri, 26 Jul 2013 12:02:51 -0700
Message-ID: <CAGrhNMzaBcUb4GHLXr5uR2g4YNSD60vcDpDKQO=S9H2jAx6pgA@mail.gmail.com>
Subject: Re: [PATCH 4/4] ALSA: oxygen: Updating jack implementation according
 new ALSA Jacks
From: Felipe Tonello <eu@felipetonello.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jul 26, 2013 at 11:56 AM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 26, 2013 at 11:25:33AM -0700, Felipe F. Tonello wrote:
>> From: "Felipe F. Tonello" <eu@felipetonello.com>
>>
>> ALSA standard jacks already are implemented using ALSA KControl.
>> So there is no need implement that itself or to use snd_jack
>> for input events only.
>
> Similar changlog comment as on the ASoC patch and...

Ok.

>
>>       snd_jack_new(chip->card, "Headphone",
>> -                  SND_JACK_HEADPHONE, &data->hp_jack);
>> +                  SND_JACK_HEADPHONE, 0, &data->hp_jack);
>>       xonar_ds_handle_hp_jack(chip);
>
> ...this really ought to be done as part of the commit that adds the
> parameter since it breaks the build until this patch is applied.

But that's why is a patch series. But as you say, are you suggesting
me to propose this changes in one patch only?

Felipe Tonello
