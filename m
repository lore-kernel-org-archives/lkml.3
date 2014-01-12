Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaALTeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:34:20 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64022 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaALTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:34:17 -0500
Message-ID: <52D2EE32.5060709@gmail.com>
Date: Sun, 12 Jan 2014 20:34:10 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 06/10] ARM: s3c64xx: pm: Add device tree based power
 domain instantiation
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com> <1389469372-17199-7-git-send-email-tomasz.figa@gmail.com> <20140112192910.GW29039@sirena.org.uk>
In-Reply-To: <20140112192910.GW29039@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.2014 20:29, Mark Brown wrote:
> On Sat, Jan 11, 2014 at 08:42:48PM +0100, Tomasz Figa wrote:
>
>> This patch adds support for registering power domains of S3C64xx SoCs
>> and binding devices to them using device tree.
>
>> +#ifdef CONFIG_OF
>> +static struct of_device_id s3c64xx_pd_matches[] = {
>> +	{ .compatible = "samsung,s3c6400-clock", },
>> +	{ .compatible = "samsung,s3c6410-clock", },
>> +	{ },
>>   };
>
> Looks like a rebasing issue?  Otherwise this looks nice.

Hmm, what's the problem here? Maybe I'm just blind, but I fail to see 
anything wrong (except that the array should be const...).

Thanks for reviewing this.

Best regards,
Tomasz
