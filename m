Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaLDGnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:43:49 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:63575 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaLDGnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:43:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAA7nrtjrQ5SpDrZRPb58zqmZrWahY3XOMWnmdH70WLr3q46_bA@mail.gmail.com>
References: <547F3C9F.8080102@arm.com>
	<20141203172526.GC7712@sirena.org.uk>
	<CAA7nrtjrQ5SpDrZRPb58zqmZrWahY3XOMWnmdH70WLr3q46_bA@mail.gmail.com>
Date: Thu, 4 Dec 2014 12:13:46 +0530
Message-ID: <CAA7nrth+h32Un2C4z106wL181eru7hwFDxMdS00X55h5Zw=-Vg@mail.gmail.com>
Subject: Re: [PATCH 2/5] ASoC: dwc: Don't allow negative use counts
From: rajeev kumar <rajeevkumar.linux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Jackson <Andrew.Jackson@arm.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 12:10 PM, rajeev kumar
<rajeevkumar.linux@gmail.com> wrote:
> On Wed, Dec 3, 2014 at 10:55 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Wed, Dec 03, 2014 at 04:38:55PM +0000, Andrew Jackson wrote:
>>
>>>       case SNDRV_PCM_TRIGGER_STOP:
>>>       case SNDRV_PCM_TRIGGER_SUSPEND:
>>>       case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
>>> -             dev->active--;
>>> +             if (dev->active > 0)
>>> +                     dev->active--;
>>
>> How is this triggering - this sounds like you're papering over some
>> other bug somewhere?

This check can be removed as it is not going to triggered.

B'rgds
~Rajeev
