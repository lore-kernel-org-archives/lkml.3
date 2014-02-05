Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaBEXgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:36:32 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63899 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaBEXga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:36:30 -0500
MIME-Version: 1.0
In-Reply-To: <52F28875.9000200@ti.com>
References: <1391608060-10760-1-git-send-email-ivan.khoronzhuk@ti.com>
	<1391608060-10760-3-git-send-email-ivan.khoronzhuk@ti.com>
	<CAL_JsqKVc2fdg1Q+TH6ro9kpJmUYyHw8FCwhORfm2_oj6GYM2Q@mail.gmail.com>
	<52F26444.5090707@ti.com>
	<CAL_JsqL6YDcZJa5xziR7dP-bEt1CO4BtL1vsO8Qm+hFwgCiQ1w@mail.gmail.com>
	<52F28875.9000200@ti.com>
Date: Wed, 5 Feb 2014 17:36:29 -0600
Message-ID: <CAL_JsqLSNrTvH2SFfA5KB8RsDqcj9zks1QaVmvYya6WQ--W7jg@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] clocksource: keystone: add bindings for keystone timer
From: Rob Herring <robherring2@gmail.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 12:52 PM, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com> wrote:
>
> On 02/05/2014 07:41 PM, Rob Herring wrote:
>>
>> On Wed, Feb 5, 2014 at 10:18 AM, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> wrote:
>>>
>>> On 02/05/2014 04:39 PM, Rob Herring wrote:
>>>>
>>>> On Wed, Feb 5, 2014 at 7:47 AM, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>>> wrote:
>>>>>
>>>>> This patch provides bindings for the 64-bit timer in the KeyStone
>>>>> architecture devices. The timer can be configured as a general-purpose
>>>>> 64-bit
>>>>> timer, dual general-purpose 32-bit timers. When configured as dual
>>>>> 32-bit
>>>>> timers, each half can operate in conjunction (chain mode) or
>>>>> independently
>>>>> (unchained mode) of each other.
>>>>
>>>> This is software configurable or h/w design time configurations?
>>>>
>>>> Rob
>>>>
>>> This is h/w design time configurations
>>
>> Then it seems like the binding should provide for describing those
>> differences either with a property or different compatible strings.
>>
>> Rob
>
> Oh..sorry, seems I didn't catch, this is configurable by software.
> These configurations are like modes in which timer can work
> and they are not different hardware IPs. It depends on driver in
> which mode it should work.

In that case,

Acked-by: Rob Herring <robh@kernel.org>
