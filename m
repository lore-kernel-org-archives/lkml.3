Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3KROZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:25:37 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62936 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3KROZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:25:30 -0500
Message-ID: <528A2356.4040501@koalo.de>
Date: Mon, 18 Nov 2013 15:25:26 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv3] ASoC: Add support for BCM2835
References: <5289F9DF.8060406@koalo.de> <20131118141637.GI30853@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131118141637.GI30853@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you!

>> diff --git a/Documentation/devicetree/bindings/sound/bcm2835-i2s.txt b/Documentation/devicetree/bindings/sound/bcm2835-i2s.txt
>> new file mode 100644
>> index 0000000..7bf1d04
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/sound/bcm2835-i2s.txt
>> @@ -0,0 +1,22 @@
>> +* Broadcom BCM2835 SoC I2S/PCM module
>> +
>> +Required properties:
>> +- compatible: "brcm,bcm2835-i2s"
>> +- reg: Register location and size
>> +       <PCM base address, size
>> +        PCM clock base address, size>;
> 
> []
> 
> Are the clocks actually a sub-block, or are they actually a separate
> unit that just happens to feed this one?

Sorry, but I don't get your point. It is a clock module that is
dedicated to the PCM module.
