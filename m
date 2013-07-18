Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab3GRSbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:31:05 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:40607 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312Ab3GRSbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:31:01 -0400
Message-ID: <51E8345F.30608@gmail.com>
Date: Thu, 18 Jul 2013 13:30:55 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: Andrew Lunn <andrew@lunn.ch>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v2 11/15] cpufreq: kirkwood-cpufreq: remove device
 tree parsing for cpu nodes
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374069984-20567-12-git-send-email-Sudeep.KarkadaNagesha@arm.com> <20130717144355.GE1026@lunn.ch> <51E7A63F.7020207@arm.com> <51E7BFFA.8010101@arm.com>
In-Reply-To: <51E7BFFA.8010101@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 05:14 AM, Sudeep KarkadaNagesha wrote:
> On 18/07/13 09:24, Sudeep KarkadaNagesha wrote:
>> On 17/07/13 15:43, Andrew Lunn wrote:
>>> On Wed, Jul 17, 2013 at 03:06:20PM +0100, Sudeep.KarkadaNagesha@arm.com wrote:
>>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>>
> [...]

>>> Are we not going a bit backwards here? You are replacing two lines
>>> with 10 lines.
>>>
>>> How about putting these 10 lines into some helper,
>>> of_get_cpu_device()?  It would be useful for spear, kirkwood and
>>> imx6q, and maybe others.
>>>
>> Yes I realised that after making changes to this and pmac32 drivers. I
>> have already made those changes in v3. I am waiting for more response
>> before posting them.
>>
> I thought of placing this helper in include/linux/of_device.h but I see:
> #include <linux/of_platform.h> /* temporary until merge */
> 
> Does this mean of_platform.h and of_device.h will be merged ?

No, I think that was probably to avoid adding includes of of_platform.h
for 100's of files. Maybe things are cleaned up enough to remove this line.

> If so, which will be the final merged one ? I would like to avoid
> changing all the header file inclusions later in users of this new helper.

of_device.h is the right place.

Rob

> 
> Regards,
> Sudeep
> 
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

