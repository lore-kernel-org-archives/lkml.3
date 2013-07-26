Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab3GZTLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:11:14 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33377 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3GZTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130726185023.GW9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
	<1374863133-6745-4-git-send-email-eu@felipetonello.com>
	<20130726185023.GW9858@sirena.org.uk>
Date: Fri, 26 Jul 2013 12:11:12 -0700
Message-ID: <CAGrhNMwcHmN7r=FtOQiPQJ10i02CTv4r=OAgYC5zL1FiRv3o7g@mail.gmail.com>
Subject: Re: [PATCH 3/4] ALSA: SoC: Updating jack implementation according new
 ALSA Jacks
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

On Fri, Jul 26, 2013 at 11:50 AM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jul 26, 2013 at 11:25:32AM -0700, Felipe F. Tonello wrote:
>> From: "Felipe F. Tonello" <eu@felipetonello.com>
>>
>> ALSA standard jacks already are implemented using ALSA KControl.
>> So there is no need implement that itself or to use snd_jack for input
>> events only.
>
> This changelog doesn't correspond to the code change - what this is
> doing is updating the ASoC jack support to add the ability to specify a
> jack index when creating a jack.  There's nothing to do with removing
> duplicate kcontrol creation here at all.
>
> The change itself seems fine but it's not accurately described.

Ok.
