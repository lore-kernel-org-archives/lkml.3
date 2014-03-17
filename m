Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbaCQNzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:55:11 -0400
Received: from 13.mo1.mail-out.ovh.net ([178.33.253.128]:45782 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756201AbaCQNzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:55:09 -0400
X-Greylist: delayed 8400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2014 09:55:09 EDT
Message-ID: <5326CBE0.1000309@overkiz.com>
Date: Mon, 17 Mar 2014 11:18:08 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>, Bo Shen <voice.shen@atmel.com>
CC: Mark Brown <broonie@kernel.org>,
        "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] ASoC: atmel: document clock properties of the wm8904
 driver
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-8-git-send-email-voice.shen@atmel.com> <20140317100219.GB8070@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140317100219.GB8070@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14656402038492592353
X-Ovh-Remote: 88.188.80.5 (col31-4-88-188-80-5.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

Le 17/03/2014 11:02, Mark Rutland a écrit :
> On Mon, Mar 17, 2014 at 09:45:40AM +0000, Bo Shen wrote:
>> From: Boris BREZILLON <b.brezillon@overkiz.com>
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>> ---
>>
>>   Documentation/devicetree/bindings/sound/atmel-wm8904.txt | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
>> index 8bbe50c..aca341c 100644
>> --- a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
>> +++ b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
>> @@ -3,6 +3,8 @@ Atmel ASoC driver with wm8904 audio codec complex
>>   Required properties:
>>     - compatible: "atmel,asoc-wm8904"
>>     - atmel,model: The user-visible name of this sound complex.
>> +  - clocks: A list of clocks needed by the wm8904 chip.
>> +  - clock-output-names: Driver related clock names. Shall contain "pck0".
> The word "driver"  doesn't need to appear in biding documents, and this
> fails to describe what it sets out to. How about the following:
>
> - clocks: a list of phandle + clock-specifier pairs, one for each entry
>    in clock-names.
Agreed.
> - clock-names: Should contain "pck0"
After thinking a bit more about it, this can be any programmable clk (pckX).

I'll fix it.

Thanks.

Best Regards,

Boris

>
> Thanks,
> Mark.

