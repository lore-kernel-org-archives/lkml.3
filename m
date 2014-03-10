Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaCJG5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 02:57:05 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1052 "EHLO
	smtp-out-129.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751583AbaCJG5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 02:57:03 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30123
Message-ID: <531D6262.3070201@metafoo.de>
Date: Mon, 10 Mar 2014 07:57:38 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com> <1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com> <20140303045952.GO2411@sirena.org.uk> <5bc570ec866541a68df5813ffbe3168e@BY2PR03MB505.namprd03.prod.outlook.com> <20140304043603.GI2411@sirena.org.uk> <0dbba1debfd149a6a5e3985349a95793@BY2PR03MB505.namprd03.prod.outlook.com>
In-Reply-To: <0dbba1debfd149a6a5e3985349a95793@BY2PR03MB505.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 04:51 AM, Li.Xiubo@freescale.com wrote:
>> Subject: Re: [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
>>
>> On Mon, Mar 03, 2014 at 07:24:36AM +0000, Li.Xiubo@freescale.com wrote:
>>
>>>>>   	/* Default to using ALC auto offset calibration mode. */
>>>>>   	snd_soc_update_bits(codec, DA7213_ALC_CTRL1,
>>>>>   			    DA7213_ALC_CALIB_MODE_MAN, 0);
>>
>>>> This one will fail.
>>
>>> Sorry, I'm not very understand why will this fail ? Before the ASoC probe,
>>> the ASoC core will set the I/O.
>>> :)
>>
>> OK, that's now been refactored.
>
> @Mark, @Lars,
>
> Has there any other problems about this patch series? And this I had tested on
> our Vybrid-Twr board based on SGTL5000 codec and SAI drivers. If not, I can
> continue with my second patches series about " Remove set_cache_io entirely from
> ASoC probe".
>
> Thanks very much.
>


It looks good to me.

