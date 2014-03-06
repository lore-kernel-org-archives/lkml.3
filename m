Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaCFId2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:33:28 -0500
Received: from smtp-out-163.synserver.de ([212.40.185.163]:1067 "EHLO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752378AbaCFId1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:33:27 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7434
Message-ID: <531832F5.4030000@metafoo.de>
Date: Thu, 06 Mar 2014 09:33:57 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: tlv320aic23: add support for SPI control
 mode
References: <1394091862-13603-1-git-send-email-jcmvbkbc@gmail.com> <20140306080720.GI13126@sirena.org.uk> <CAMo8BfJit6Bgafi7Fwgwmtn36QZH6XsHucdPdeffjgJn0byDpw@mail.gmail.com>
In-Reply-To: <CAMo8BfJit6Bgafi7Fwgwmtn36QZH6XsHucdPdeffjgJn0byDpw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 09:26 AM, Max Filippov wrote:
> Hi Mark,
>
> On Thu, Mar 6, 2014 at 12:07 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Thu, Mar 06, 2014 at 11:44:22AM +0400, Max Filippov wrote:
>>
>>> -     select SND_SOC_TLV320AIC23 if I2C
>>> +     select SND_SOC_TLV320AIC23 if SND_SOC_I2C_AND_SPI
>>
>> We're moving towards having drivers have separate bus drivers rather
>> than in one file - take a look at how drivers like ad193x handle this.
>
> Thanks for the pointer, but... ad193x has spi and i2c in single source
> in both linus and alsa-kernel trees. Confused.
>

It's in the ASoC tree: 
http://git.kernel.org/cgit/linux/kernel/git/broonie/sound.git/commit/sound/soc/codecs/?h=for-next&id=6c3d713e6d32706999689e379a9098afb4cd8a2c
