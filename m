Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaJHODK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:03:10 -0400
Received: from rhcavuit02.kulnet.kuleuven.be ([134.58.240.130]:54888 "EHLO
	cavuit02.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753800AbaJHODH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:03:07 -0400
X-KULeuven-Envelope-From: bart.tanghe@thomasmore.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: A97D41280DA.A2068
X-KULeuven-Information: Katholieke Universiteit Leuven
Message-ID: <54354409.7090105@thomasmore.be>
Date: Wed, 08 Oct 2014 16:02:49 +0200
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Bart Tanghe <bart.tanghe@thomasmore.be>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: matt.porter@linaro.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH v7]pwm: add BCM2835 PWM driver
References: <1412763272-24269-1-git-send-email-bart.tanghe@thomasmore.be> <20141008121935.GB7357@ulmo.nvidia.com>
In-Reply-To: <20141008121935.GB7357@ulmo.nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-08 14:19, Thierry Reding wrote:
> On Wed, Oct 08, 2014 at 12:14:32PM +0200, Bart Tanghe wrote:
>> Add pwm driver for Broadcom BCM2835 processor (Raspberry Pi)
>>
>> Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
>> ---
>> Changed in v7:
>>  - clean up the shameful clk_enable error handling introduced in v6
>>  - clean up the code nits
>>
>> diff --git a/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt b/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
>> new file mode 100644
>> index 0000000..d5162db
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
>> @@ -0,0 +1,27 @@
>> +BCM2835 PWM controller (Raspberry Pi controller)
>> +
>> +Required properties:
>> +- compatible: should be "brcm,bcm2835-pwm"
>> +- reg: physical base address and length of the controller's registers
>> +- clock: this clock defines the base clock frequency of the pwm
>> +hardware system, the period and the duty_cycle of the pwm signal is a
>> +multiple of the base period
> 
> This needs to document the #pwm-cells property. I can fix that up when
> applying, though.
> 
> Let's give Stephen and others a chance to give this another look.
> 
> Thierry
> 
Perfect, thanks.

Bart
