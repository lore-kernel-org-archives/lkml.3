Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaDDMjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:39:40 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:34295 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaDDMjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:39:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAEgOgz4ZbA7+Og2sjsAcjjw7OiJa_FL1A01DEzGK1OKg36-A2Q@mail.gmail.com>
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com>
	<1396523431-14519-2-git-send-email-harinik@xilinx.com>
	<20140403213446.GB14763@sirena.org.uk>
	<CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com>
	<20140404100919.GO14763@sirena.org.uk>
	<CAFcVECLDyfFSZFk9fzFKsr6pM=f1nwzGAhjX17z=NsbvWpiDew@mail.gmail.com>
	<CAEgOgz4ZbA7+Og2sjsAcjjw7OiJa_FL1A01DEzGK1OKg36-A2Q@mail.gmail.com>
Date: Fri, 4 Apr 2014 18:09:35 +0530
Message-ID: <CAFcVECLAw69ss83OQRMfwQfwAFYNA8iyVG_SZQncLxWfF1mW4A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] devicetree: Add devicetree bindings documentation
 for Cadence SPI
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 4, 2014 at 5:54 PM, Peter Crosthwaite
<peter.crosthwaite@xilinx.com> wrote:
> On Fri, Apr 4, 2014 at 10:14 PM, Harini Katakam
> <harinikatakamlinux@gmail.com> wrote:
>> Hi Mark,
>>
>> On Fri, Apr 4, 2014 at 3:39 PM, Mark Brown <broonie@kernel.org> wrote:
>>> On Fri, Apr 04, 2014 at 08:30:38AM +0530, Harini Katakam wrote:
>>>> On Fri, Apr 4, 2014 at 3:04 AM, Mark Brown <broonie@kernel.org> wrote:
>>>> > On Thu, Apr 03, 2014 at 04:40:31PM +0530, Harini Katakam wrote:
>>>
>>>> >> +Optional properties:
>>>> >> +- num-cs             : Number of chip selects used.
>>>
>>>> > How does this translate to the hardware?
>>>
>>>> This IP can drive 4 slaves.
>>>> The CS line to be driven is selected in spi device structure and
>>>> that is driven by the software.
>>>
>>> So why specify this in the binding at all?  If the device always has the
>>> same number of chip selects it's redundant.
>>
>> I'm sorry, I should have explained that better.
>> The IP can support upto 4 chip selects.
>> The num-cs value here is the number of chip selects actually used on the board.
>>
>
> Just to clarify - do you mean SoC or board level?
>

I mean board level.
One more reason it will be useful to keep this property is because
there is support for adding a decoder where extended slaves can be selected
through the IP's control register.
(This is not currently implemented in the driver but will be in the future.)

Regards,
Harini
