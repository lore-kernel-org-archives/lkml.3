Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3JUKsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:48:02 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14031 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3JUKr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:47:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Oct 2013 03:47:58 -0700
Message-ID: <52650CB2.9030409@nvidia.com>
Date: Mon, 21 Oct 2013 16:44:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob@landley.net" <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [PATCH V5 3/3] drivers/rtc/rtc-as3722: add RTC driver
References: <1381321761-8898-1-git-send-email-ldewangan@nvidia.com> <1381321761-8898-4-git-send-email-ldewangan@nvidia.com> <20131010152446.1715e64b70ddd0281a3971e9@linux-foundation.org> <20131010224748.GW21581@sirena.org.uk>
In-Reply-To: <20131010224748.GW21581@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 October 2013 04:17 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Oct 10, 2013 at 03:24:46PM -0700, Andrew Morton wrote:
>
>>> +#ifdef CONFIG_PM
>> Most (but not all!) rtc drivers use CONFIG_PM_SLEEP.  People have madly
>> mucked with CONFIG_PM* and I don't know the difference and I don't know
>> what's going on and I don't know of a convenient place to go to find
>> out.  If you work it out, please be sure to tell me!  But as soon as I
>> figure it out I'm sure they'll go and madly muck with it again.
> The two effective options for this stuff are PM_SLEEP (for system
> suspend) and PM_RUNTIME (for runtime suspend which RTCs are unlikely to
> use I guess).  PM mostly just enables selection of the other two.

I think, correct defs is  CONFIG_PM_SLEEP here. I will re-spin this patch.
