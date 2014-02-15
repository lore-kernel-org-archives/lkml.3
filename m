Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaBOLrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 06:47:53 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44534 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaBOLru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 06:47:50 -0500
Message-ID: <52FF5409.8050903@kernel.org>
Date: Sat, 15 Feb 2014 11:48:25 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Matt Porter <mporter@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Devicetree List <devicetree@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Linux IIO List <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/6] IIO pulse capture support for TI ECAP
References: <1391626901-31684-1-git-send-email-mporter@linaro.org> <52F29DBD.9050305@cogentembedded.com>
In-Reply-To: <52F29DBD.9050305@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 20:23, Sergei Shtylyov wrote:
> Hello.
>
> On 02/05/2014 10:01 PM, Matt Porter wrote:
>
> [...]
>
>> This series adds support for PWM capture devices within IIO and
>> adds a TI ECAP IIO driver.
>
>> PWM capture devices are supported using a new IIO "pulse" channel type.
>
>> The IIO ECAP driver implements interrupt driven triggered buffer capture
>> only as raw sample reads are not applicable to this hardware.
>> Initially, the driver supports a single pulse width measurement with
>> configurable polarity. The ECAP hardware can support measurement of a
>> complete period and duty cycle but this is not yet implemented.
>

> How about pulse counting? I have the hardware that can also
> countpulses in addition to measuring the periods, so I'm interested
> in this work (initially I supported it in driver/misc/ but it got
> turned down for iio).
>
I'm afraid I'd forgotten this completely if you can dig out some links
to that discussion it would be great. Only one I can find right now
is a request that you post an ABI introducing this as a generic pulse
counter rather than a speed measurement.

Good point though - under my previous sketched outline, perhaps

in_waveform_cyclecount_input?  (I would imagine that it doesn't come
out needing scaling!)

> WBR, Sergei
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

