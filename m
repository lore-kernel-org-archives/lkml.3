Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaIKGaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 02:30:19 -0400
Received: from www.augenpunkt.de ([213.239.207.9]:60058 "EHLO
	www.augenpunkt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaIKGaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 02:30:16 -0400
Message-ID: <541138D0.6090808@lategoodbye.de>
Date: Thu, 11 Sep 2014 07:53:20 +0200
From: Stefan Wahren <info@lategoodbye.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 2/3] ARM: regulator: add Freescale MXS regulator driver
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de>	<1410089869-6611-3-git-send-email-info@lategoodbye.de>	<20140909182211.GG3896@leverpostej>	<540F523D.4010904@lategoodbye.de>	<20140910141853.GA4994@leverpostej>	<20140910151316.GG7960@sirena.org.uk>	<54108B34.6010701@lategoodbye.de> <CAOMZO5BEN_DQOyhrx5ZB7y6DoDvqbLvDyJfAabOvtUvKOiGHOA@mail.gmail.com>
In-Reply-To: <CAOMZO5BEN_DQOyhrx5ZB7y6DoDvqbLvDyJfAabOvtUvKOiGHOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

Am 10.09.2014 20:54, schrieb Fabio Estevam:
> Hi Stefan,
>
> On Wed, Sep 10, 2014 at 2:32 PM, Stefan Wahren <info@lategoodbye.de> wrote:
>> Hi Mark,
>>
>> Am 10.09.2014 17:13, schrieb Mark Brown:
>>>
>>> On Wed, Sep 10, 2014 at 03:18:53PM +0100, Mark Rutland wrote:
>>>>
>>>> On Tue, Sep 09, 2014 at 08:17:17PM +0100, Stefan Wahren wrote:
>>>
>>>
>>> Ugh, this looks like it might be a regulator driver but since the
>>> subject line was "ARM: " I deleted it unread - if your changelog looks
>>> different to all the other changelogs in the subsystem it probably needs
>>> changing.
>>
>>
>> sorry about the confusion, i will remove ARM in the next version.
>>
>> Changelog? I didn't send a changelog because it was my first version.
>>
>> Should i resend this version only to you?
>
> In the cover letter of this RFC series you mentioned that this has not
> been tested on real hardware.
>
> What about sending a new version of this series (with the RFC prefix
> removed and with Mark Rutland's suggestion implemented) tested on a
> mx28 board and also with the Subject of the regulator patch changed to
> 'regulator: add support for mxs regulator" with Mark Brown on Cc?
>

that's the same idea i had about the first real version of my patch. 
Unfortunately i can do the porting only in my spare time. So i try to 
avoid with the RFC series the situation, that i spend many days in 
development and testing, but after it the regulator guys says it went in 
the complete wrong direction. The advice about the anatop regulator was 
helpful, but there is still some unsureness.

I will try to get a Duckbill, so i can do testing at home.

Thanks

Stefan
