Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3GCFXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 01:23:05 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38109 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3GCFXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 01:23:03 -0400
Message-ID: <51D3B52D.5020304@gmail.com>
Date: Wed, 03 Jul 2013 13:22:53 +0800
From: Bo Shen <bard.shen@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        richard.genoud@gmail.com, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 1/2] ASoC: atmel_ssc_dai: move set dma data
 to startup callback
References: <1372755849-19546-1-git-send-email-voice.shen@atmel.com> <1372755849-19546-2-git-send-email-voice.shen@atmel.com> <51D2F0FA.6040409@metafoo.de> <51D37C59.3090306@atmel.com>
In-Reply-To: <51D37C59.3090306@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On 7/3/2013 09:20, Bo Shen wrote:
> Hi Lars-Peter,
>
> On 7/2/2013 23:25, Lars-Peter Clausen wrote:
>> On 07/02/2013 11:04 AM, Bo Shen wrote:
>> [...]
>>> +    dma_params->substream = substream;
>>
>> Unrelated to this patch, but having a substream field in the
>> dma_params seems
>> to be redundant, since you need to know the substream to get the
>> dma_params in
>> the first place. Looking at the code it also seems to be unused other
>> than this
>> assignment. Maybe you can send a follow up patch to remove it.
>>
>> [...]
>>
>
> Yes, this is redundant. I will remove it in next version patches.

Sorry for mistake, this substream parameter need by the interrupt for 
PDC transfer, so, I will keep it.

Best Regards,
Bo Shen

