Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaAPBfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:35:31 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:18122 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752517AbaAPBfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:35:24 -0500
Message-ID: <52D736E0.90207@atmel.com>
Date: Thu, 16 Jan 2014 09:33:20 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <broonie@kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-sound@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mark Brown <broonie@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Binding: atmel-wm8904: add option to choose clock
References: <1389669956-2304-1-git-send-email-voice.shen@atmel.com> <1389669956-2304-4-git-send-email-voice.shen@atmel.com> <20140115115417.GA9558@ns203013.ovh.net>
In-Reply-To: <20140115115417.GA9558@ns203013.ovh.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi J,

On 01/15/2014 07:54 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 11:25 Tue 14 Jan     , Bo Shen wrote:
>> Add the option to choose clock output on which pin connect to SSC.
>> Default is on TK pin to SSC, add clk_from_rk_pin option, the clock
>> is on RK pin to SSC.
>>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>> ---
>>
>>   Documentation/devicetree/bindings/sound/atmel-wm8904.txt | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
>> index 8bbe50c..68a5c1a 100644
>> --- a/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
>> +++ b/Documentation/devicetree/bindings/sound/atmel-wm8904.txt
>> @@ -33,6 +33,8 @@ Required properties:
>>
>>   Optional properties:
>>     - pinctrl-names, pinctrl-0: Please refer to pinctrl-bindings.txt
>> +  - clk_from_rk_pin: according to hardware design, clk privide on rk pin
> 							  provide
>
> 	?? no example?

If this patch set is acceptable. The sama5 audio will use it (I will 
send patch after this patch set). Do I still need to put the example in 
the binding document?

>> +    to ssc device
>>
>>   Example:
>>   sound {
>> --
>> 1.8.5.2
>>

Best Regards,
Bo Shen
