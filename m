Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3G0HUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 03:20:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11467 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3G0HUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 03:20:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 27 Jul 2013 00:20:44 -0700
Message-ID: <51F37785.9040604@nvidia.com>
Date: Sat, 27 Jul 2013 13:02:21 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
References: <1374755343-32573-1-git-send-email-ldewangan@nvidia.com> <51F2985F.60202@wwwdotorg.org> <20130726163528.GS9858@sirena.org.uk> <51F2A706.9080005@wwwdotorg.org>
In-Reply-To: <51F2A706.9080005@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 July 2013 10:12 PM, Stephen Warren wrote:
> On 07/26/2013 10:35 AM, Mark Brown wrote:
>> On Fri, Jul 26, 2013 at 09:40:15AM -0600, Stephen Warren wrote:
>>
>>> Given there's only 1 battery, I think "back-" is redundant in
>>> the property names. Since that shortens the names a bit, I'd
>>> suggest spelling everything out in full, perhaps:
>> Isn't there an integrated charger on the PMIC?  If there is then
>> it's useful to identify which is being talked about (even if it
>> should be relatively obvious).
> Oh yes, that's probably true. This is of course the binding for the
> RTC sub-module in the PMIC though.
>

I have currently Palma series 2 devices tps65913 and tps80036. TPS80036 
supports the charging of main battery. Both chip support the backup 
battery charging. Hence it is good to name the back-* here.


