Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbbAURU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:20:59 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44150 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbAURUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:20:49 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20150121165250.GG13715@earth.universe>
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com> <20150121165250.GG13715@earth.universe>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v6 0/7] Add initial support for DA9150 Charger & Fuel-Gauge IC
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Date: Wed, 21 Jan 2015 17:19:38 +0000
To: Sebastian Reichel <sre@kernel.org>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Jonathan Cameron <jic23@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-iio@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        support.opensource@diasemi.com
Message-ID: <C1079F30-5D1D-45AA-A129-FE1E68EA5DC5@jic23.retrosnub.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21 January 2015 16:52:50 GMT+00:00, Sebastian Reichel <sre@kernel.org> wrote:
>Hi,
>
>On Wed, Jan 21, 2015 at 03:46:25PM +0000, Adam Thomson wrote:
>> This patch set adds initial support for the Dialog DA9150 Integrated
>Charger &
>> Fuel-Gauge IC. The device also provides GPIO and GPADC functionality.
>> 
>> In this patch set the following is provided:
>>  - MFD Core support and DT bindings documentation.
>>  - IIO GPADC support and DT bindings documentation.
>>  - Power Supply Charger support and DT bindings documentation.
>>  - Update to MAINTAINERS file to add DA9150 files to Dialog support
>list.
>> 
>> To keep patch submission from being too large, support for GPIO and
>Fuel-Gauge
>> will come after initial support patches are accepted.
>> 
>> This patch set is baselined against the v3.19-rc5 kernel version.
>> 
>> Changes in v6:
>> - For GPADC driver, Use lower case extended names for IIO GPADC
>channels, and
>>   remove extended names for GPIO related channels.
>> - For charger driver, revert to no devm IRQ request/free functions as
>ordering
>>   is important, and probe failure scenario was not being correctly
>covered. A
>>   helper function for free IRQs has been added to make code cleaner.
>
>Probably a devm_ variant of power_supply_register should be created,
>but for now this is ok for me.
>
>Jonathan, Lee: I assume you are ok with the whole patchset going
>through the power supply subsystem?
>
Fine by me if either power supply or MFD.

Jonathan
>-- Sebastian

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
