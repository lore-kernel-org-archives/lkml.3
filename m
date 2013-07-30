Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab3G3MQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:16:08 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60913 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3G3MQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:16:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130730120304.GU9858@sirena.org.uk>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
 <1375180329-4860-9-git-send-email-richard.genoud@gmail.com> <20130730120304.GU9858@sirena.org.uk>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 30 Jul 2013 14:15:45 +0200
Message-ID: <CACQ1gAj=HpEbiNTaPrGO-XxgVy9s-0Nya+pp4-nh7TzOLhxrNg@mail.gmail.com>
Subject: Re: [PATCH v6 8/8] ASoC: sam9x5: get codec MCLK via device tree
To: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/30 Mark Brown <broonie@kernel.org>:
> On Tue, Jul 30, 2013 at 12:32:09PM +0200, Richard Genoud wrote:
>
>> --- a/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
>> +++ b/Documentation/devicetree/bindings/sound/atmel-sam9x5-wm8731-audio.txt
>> @@ -8,6 +8,8 @@ Required properties:
>>    - atmel,audio-routing: A list of the connections between audio components.
>>      Each entry is a pair of strings, the first being the connection's sink,
>>      the second being the connection's source.
>> +  - clocks: Must contain an entry for the codec master clock.
>> +  - clock-names : Must be "mclk" (clock that feeds the codec master clock)
>
> This should be part of the CODEC binding, not part of the machine driver
> binding.  The machine driver should currently have the code to fetch the
> clock but since the clock physically goes to the CODEC it should be part
> of the CODEC binding.
That makes sense.

Thanks !
