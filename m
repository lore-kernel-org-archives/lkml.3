Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3GCBU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 21:20:56 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:47665 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751281Ab3GCBUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 21:20:55 -0400
Message-ID: <51D37C59.3090306@atmel.com>
Date: Wed, 3 Jul 2013 09:20:25 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        <richard.genoud@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-sound@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH 1/2] ASoC: atmel_ssc_dai: move set dma data
 to startup callback
References: <1372755849-19546-1-git-send-email-voice.shen@atmel.com> <1372755849-19546-2-git-send-email-voice.shen@atmel.com> <51D2F0FA.6040409@metafoo.de>
In-Reply-To: <51D2F0FA.6040409@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter,

On 7/2/2013 23:25, Lars-Peter Clausen wrote:
> On 07/02/2013 11:04 AM, Bo Shen wrote:
> [...]
>> +	dma_params->substream = substream;
>
> Unrelated to this patch, but having a substream field in the dma_params seems
> to be redundant, since you need to know the substream to get the dma_params in
> the first place. Looking at the code it also seems to be unused other than this
> assignment. Maybe you can send a follow up patch to remove it.
>
> [...]
>

Yes, this is redundant. I will remove it in next version patches.

Best Regards,
Bo Shen
