Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaCFIiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:38:07 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:39717 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaCFIiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:38:05 -0500
MIME-Version: 1.0
In-Reply-To: <531832F5.4030000@metafoo.de>
References: <1394091862-13603-1-git-send-email-jcmvbkbc@gmail.com>
	<20140306080720.GI13126@sirena.org.uk>
	<CAMo8BfJit6Bgafi7Fwgwmtn36QZH6XsHucdPdeffjgJn0byDpw@mail.gmail.com>
	<531832F5.4030000@metafoo.de>
Date: Thu, 6 Mar 2014 12:38:04 +0400
Message-ID: <CAMo8BfKMz1d9zpbrb=JUMvjs4bE=ah1DfvM8f0KG5=uJuNJKxw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: tlv320aic23: add support for SPI
 control mode
From: Max Filippov <jcmvbkbc@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 12:33 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 03/06/2014 09:26 AM, Max Filippov wrote:
>>
>> Hi Mark,
>>
>> On Thu, Mar 6, 2014 at 12:07 PM, Mark Brown <broonie@kernel.org> wrote:
>>>
>>> On Thu, Mar 06, 2014 at 11:44:22AM +0400, Max Filippov wrote:
>>>
>>>> -     select SND_SOC_TLV320AIC23 if I2C
>>>> +     select SND_SOC_TLV320AIC23 if SND_SOC_I2C_AND_SPI
>>>
>>>
>>> We're moving towards having drivers have separate bus drivers rather
>>> than in one file - take a look at how drivers like ad193x handle this.
>>
>>
>> Thanks for the pointer, but... ad193x has spi and i2c in single source
>> in both linus and alsa-kernel trees. Confused.
>>
>
> It's in the ASoC tree:
> http://git.kernel.org/cgit/linux/kernel/git/broonie/sound.git/commit/sound/soc/codecs/?h=for-next&id=6c3d713e6d32706999689e379a9098afb4cd8a2c

Thank you Lars-Peter. I'll do the same split for aic23.

-- 
Thanks.
-- Max
