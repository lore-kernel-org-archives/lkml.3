Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab3H3UME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:12:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41148 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3H3UMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:12:01 -0400
Message-ID: <5220FC8C.90908@wwwdotorg.org>
Date: Fri, 30 Aug 2013 14:11:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
        thierry.reding@gmail.com, grant.likely@linaro.org,
        linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for Freescale
 FTM PWM
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com> <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com> <5EFBF478-CFCC-4E66-A279-25F4A338B05B@kernel.crashing.org>
In-Reply-To: <5EFBF478-CFCC-4E66-A279-25F4A338B05B@kernel.crashing.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 01:19 PM, Kumar Gala wrote:
> Should have at least something w/regards to a commit message.
> 
> On Aug 20, 2013, at 10:07 PM, Xiubo Li wrote:
> 
>> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
>> ---
>> .../devicetree/bindings/pwm/fsl-ftm-pwm.txt        | 52 ++++++++++++++++++++++
>> 1 file changed, 52 insertions(+)
>> create mode 100644 Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
>>
>> diff --git a/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt b/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
>> new file mode 100644
>> index 0000000..698965b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
>> @@ -0,0 +1,52 @@
>> +Freescale FTM PWM controller
>> +
>> +Required properties:
>> +- compatible: should be "fsl,vf610-ftm-pwm"
>> +- reg: physical base address and length of the controller's registers
>> +- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
>> +  First cell specifies the per-chip channel index of the PWM to use, the
>> +  second cell is the period in nanoseconds and bit 0 in the third cell is
>> +  used to encode the polarity of PWM output. Set bit 0 of the third in PWM
>> +  specifier to 1 for inverse polarity & set to 0 for normal polarity.
>> +- fsl,pwm-clk-ps: the ftm0 pwm clock's prescaler, divide-by 2^n(n = 0 ~ 7).
>> +- fsl,pwm-cpwm: Center-Aligned PWM (CPWM) mode.
> 
> Should describe this in more detail, what does the value actually mean for what modes there are?

Assuming "CPWM" is clearly explained in the HW documentation for this
chip (I have no idea if that's actually the case), then is it still
necessary to explain what this means in *detail*? Perhaps simply "see
section XXX in the TRM" or "see register XXX, bit YYY in the HW
documentation" would be enough?
