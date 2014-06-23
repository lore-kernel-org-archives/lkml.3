Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaFWXGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 19:06:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbaFWXGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 19:06:53 -0400
Message-ID: <53A8B306.1010903@suse.de>
Date: Tue, 24 Jun 2014 01:06:46 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@samsung.com>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Documentation: devicetree: Fix s2mps11 and s5m8767
 typos
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>	<1403486483-4063-2-git-send-email-afaerber@suse.de> <CAK5sBcGM6TLiMfhktGaeL9hvPFbAXN6mWFq=irWUVHnZi=BWNg@mail.gmail.com>
In-Reply-To: <CAK5sBcGM6TLiMfhktGaeL9hvPFbAXN6mWFq=irWUVHnZi=BWNg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.06.2014 05:21, schrieb Sachin Kamat:
> On Mon, Jun 23, 2014 at 6:51 AM, Andreas Färber <afaerber@suse.de> wrote:
>> It's LDO2, not LD02.
>>
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>> ---
>>  Documentation/devicetree/bindings/mfd/s2mps11.txt                 | 2 +-
>>  Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
>> index d81ba30..55ab4f4 100644
>> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
>> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
>> @@ -81,7 +81,7 @@ as per the datasheet of s2mps11.
>>                   - valid values for n are:
>>                         - S2MPS11: 1 to 38
>>                         - S2MPS14: 1 to 25
>> -                 - Example: LDO1, LD02, LDO28
>> +                 - Example: LDO1, LDO2, LDO28
>>         - BUCKn
>>                   - valid values for n are:
>>                         - S2MPS11: 1 to 10
>> diff --git a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
>> index d290988..2019131 100644
>> --- a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
>> +++ b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
>> @@ -86,7 +86,7 @@ as per the datasheet of s5m8767.
>>
>>         - LDOn
>>                   - valid values for n are 1 to 28
>> -                 - Example: LDO1, LD02, LDO28
>> +                 - Example: LDO1, LDO2, LDO28
>>         - BUCKn
>>                   - valid values for n are 1 to 9.
>>                   - Example: BUCK1, BUCK2, BUCK9
>> --
> 
> Very keen observation :)
> 
> Reviewed-by: Sachin Kamat <sachin.kamat@samsung.com>

A font that distinguishes the zero with a dot or dash helps! :)

I was wondering which character to type, and found two undocumented
s5m8767_pmic properties downstream (s5m-core,enable-low-jitter and
s5m-core,device_type = <0x2>), which I then left out.

Cheers,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
