Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763274Ab3DCJg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:36:28 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14069 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763201Ab3DCJg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:36:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 03 Apr 2013 02:36:25 -0700
Message-ID: <515BF757.3030507@nvidia.com>
Date: Wed, 3 Apr 2013 15:03:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tiwai@suse.de" <tiwai@suse.de>, "perex@perex.cz" <perex@perex.cz>
Subject: Re: [PATCH] sound: soc: tegra: do not provide PAUSE/RESUME in hardware
 info
References: <1364980781-2204-1-git-send-email-ldewangan@nvidia.com> <515C03BC.3040301@metafoo.de>
In-Reply-To: <515C03BC.3040301@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 April 2013 03:56 PM, Lars-Peter Clausen wrote:
> On 04/03/2013 11:19 AM, Laxman Dewangan wrote:
>> Tegra PCM driver uses the dmaengine based DMA driver and Tegra DMA
>> driver does not support the pause/resume functionality as hardware
>> does not support it.
>>
>> ALSA driver support the sw based pause/resume functionality if hardware
>> does not support it and in this case, hw driver should not provide
>> the hardware info with PAUSE/RESUME bit enable.
>>
>> Remmoving the SNDRV_PCM_INFO_PAUSE and SNDRV_PCM_INFO_RESUME from hardware
>> info and using the snd_dmaengine_pcm_trigger() for pcm_trigger callback.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Hm, I sent out the same patch just half an our or so ago.
>


Then I lost the race. I was struggling with sdcard  until I bought the 
new one.
