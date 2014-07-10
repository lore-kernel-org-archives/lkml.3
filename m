Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaGJHif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:38:35 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:48739 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaGJHid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:38:33 -0400
Message-ID: <53BE42F6.2090004@mm-sol.com>
Date: Thu, 10 Jul 2014 10:38:30 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [RFC PATCH v2 3/5] rtc: add qpnp rtc driver
References: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com> <1404393243-7324-4-git-send-email-svarbanov@mm-sol.com> <53BD84E1.4030602@codeaurora.org>
In-Reply-To: <53BD84E1.4030602@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 07/09/2014 09:07 PM, Stephen Boyd wrote:
> On 07/03/14 06:14, Stanimir Varbanov wrote:
>> A 32bits RTC is housed inside PMIC. The RTC driver uses QPNP
>> SPMI interface to communicate with the PMIC RTC module.
>>
>> The RTC device is divided into two sub-peripherals:
>>  - RTC read-write peripheral having basic RTC registers
>>  - alarm peripheral for controlling alarm
>>
>> These two RTC peripherals are childrens of QPNP SPMI bus. They
>> use regmap to read/write to its registers into PMIC.
>>
> 
> What happened to using Josh's patch for rtc-pm8xxx.c[1]? That seems
> easier than adding an entire new driver for almost the same hardware.
> 

Ups, I completely forgot about Josh's patch, thanks for the reminder.
Nevermind, the intention of the patch set was to get agreement on the
approach of the qpnp-spmi driver. The rtc is just slightly reworked to
platform driver downstream rtc driver. And last but not least I've used
rtc to test the approach and as a example of PMIC function/peripheral
driver.

I will see what efforts are needed to reuse rtc-pm8xxx.

> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/207665.html
> 

-- 
regards,
Stan
