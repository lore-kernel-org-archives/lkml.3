Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaALTZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:25:49 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61001 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaALTZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:25:46 -0500
Message-ID: <52D2EC32.6000306@gmail.com>
Date: Sun, 12 Jan 2014 20:25:38 +0100
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
Subject: Re: [PATCH RFC 01/10] ARM: s3c64xx: pm: Use name field of generic_pm_domain
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com> <1389469372-17199-2-git-send-email-tomasz.figa@gmail.com> <20140112192040.GU29039@sirena.org.uk>
In-Reply-To: <20140112192040.GU29039@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12.01.2014 20:20, Mark Brown wrote:
> On Sat, Jan 11, 2014 at 08:42:43PM +0100, Tomasz Figa wrote:
>
>>   static struct s3c64xx_pm_domain s3c64xx_pm_irom = {
>> -	.name = "IROM",
>>   	.ena = S3C64XX_NORMALCFG_IROM_ON,
>>   	.pd = {
>> +		.name = "domain_irom",
>
> This is nitpicking a bit but are you sure this is actually a
> beautification of the name?  It's mainly the domain_ bit, mostly since
> I'd expect that if it's not obvious that this is a power domain the core
> logging would be changed rather than tweaking the name of every power
> domain user.
>

Hmm, that's a really good point. A separate patch might change this and 
I could drop the "controversial" part of this patch ;).

Best regards,
Tomasz
