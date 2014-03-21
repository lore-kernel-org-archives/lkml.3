Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbaCUCyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:54:15 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:24179 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932713AbaCUCyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:54:12 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 22:54:12 EDT
Message-ID: <532BA898.90604@atmel.com>
Date: Fri, 21 Mar 2014 10:48:56 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, Boris BREZILLON <b.brezillon@overkiz.com>,
        "Rob Herring" <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] ASoC: atmel: document clock properties of the wm8904
 driver
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-8-git-send-email-voice.shen@atmel.com> <20140317115518.GD11706@sirena.org.uk> <532931C3.4080909@atmel.com> <20140319102800.GW11706@sirena.org.uk> <532A5481.6000008@atmel.com> <20140320134744.GF11706@sirena.org.uk>
In-Reply-To: <20140320134744.GF11706@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark Brown,

On 03/20/2014 09:47 PM, Mark Brown wrote:
> On Thu, Mar 20, 2014 at 10:37:53AM +0800, Bo Shen wrote:
>
>> For this, in my mind, I think we need add following parameters in DT.
>> 1. sysclk_src_from_fll --> we need do nothing.
>
> No, how would this work?  If nothing else the FLL needs configuration.

Only configure it in machine driver. Then no DT operation.

>> 2. sysclk_src_from_mclk
>>     2.1 use_external_xtal --> we need clock_frequency
>>     2.2 !use_external_xtal --> we need retrieve clock and clock_frequency.
>
> No, this is all handled in the clock binding.  If there's a fixed rate
> clock the device tree should have a fixed rate clock provided.
>
>> Does this acceptable? Or any other better suggestion for this?
>
> Just have the device tree describe the hardware and provide a way of
> specifying an optional MCLK.
>

I will implement an RFC patch, please help review it. Thanks.

Best Regards,
Bo Shen
