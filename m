Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaIZAea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:34:30 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47254 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaIZAe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:34:28 -0400
Message-ID: <5424B47F.9010506@gmail.com>
Date: Thu, 25 Sep 2014 17:34:07 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jonathan Richardson <jonathar@broadcom.com>
CC: Scott Branden <sbranden@broadcom.com>, Christian Daudt <bcm@fixthebug.org>,
        Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, JD Zheng <jdzheng@broadcom.com>,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ray Jui <rjui@broadcom.com>
Subject: Re: [PATCH v2 0/6] Add initial support for Broadcom Cygnus SoC
References: <Jonathan Richardson <jonathar@broadcom.com> <1411507057-14771-1-git-send-email-jonathar@broadcom.com> <54248344.5030308@broadcom.com> <54248791.9060805@gmail.com> <5424AFD2.2070406@gmail.com> <5424B335.6000602@broadcom.com>
In-Reply-To: <5424B335.6000602@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 05:28 PM, Jonathan Richardson wrote:
> On 14-09-25 05:14 PM, Florian Fainelli wrote:
>> Scott, Jonathan,
>>
>> On 09/25/2014 02:22 PM, Florian Fainelli wrote:
>>> Hi Scott,
>>>
>>> On 09/25/2014 02:04 PM, Scott Branden wrote:
>>>> Hi Matt/Christian (and others),
>>>>
>>>> We would like to move forward in getting our base Cygnus support into
>>>> the mainline kernel.  From there we will be able to contribute
>>>> additional drivers.
>>>>
>>>> Is somebody willing to accept this pull request to get this patchset
>>>> accepted by the open source community?
>>>
>>> I am fine with taking the ARM patches and putting them at
>>> http://github/brcm/linux.git, with C code in cygnus/board and the Device
>>> Tree files in cygnus/dt for instance?
>>>
>>> The clock driver patch will have to go through Mike Turquette's tree
>>> unless he wants to delegate that one.
>>
>> Could you resend patch 3 without the clock binding, patch 4 without the
>> clocks node, and patch 6 without the drivers/clk changes? Once you do
>> that, I can assemble these patches quickly and send a pull request which
>> does only contain ARM SoC and DTS changes, and you can get the clock
>> driver to be reviewed separately by its maintainer?
> 
> The serial driver needs a clock so probably better not to pull out the
> clock nodes. It's part of the core functionality we'd like in the
> initial Cygnus support. I didn't hear from Mike (cc'd), though Mark
> reviewed it.

I just sent out the pull request, we'll see how it goes from there. Thanks!
--
Florian
