Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab3J2L5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:57:51 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11762 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3J2L5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:57:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 29 Oct 2013 04:52:52 -0700
Message-ID: <526FA29F.2060004@nvidia.com>
Date: Tue, 29 Oct 2013 17:27:19 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
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
Subject: Re: [PATCH V6 3/3] drivers/rtc/rtc-as3722: add RTC driver
References: <1382356041-30973-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1382356041-30973-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Can you please review this patch?
If it is lost then I will be happy to repost it.

Thanks,
Laxman

On Monday 21 October 2013 05:17 PM, Laxman Dewangan wrote:
> The ams AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc.
>
> Add a driver to support accessing the RTC found on the ams AS3722
> PMIC using RTC framework.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
>

