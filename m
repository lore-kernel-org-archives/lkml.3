Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaBERlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:41:40 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:45912 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaBERlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:41:35 -0500
MIME-Version: 1.0
In-Reply-To: <52F26444.5090707@ti.com>
References: <1391608060-10760-1-git-send-email-ivan.khoronzhuk@ti.com>
	<1391608060-10760-3-git-send-email-ivan.khoronzhuk@ti.com>
	<CAL_JsqKVc2fdg1Q+TH6ro9kpJmUYyHw8FCwhORfm2_oj6GYM2Q@mail.gmail.com>
	<52F26444.5090707@ti.com>
Date: Wed, 5 Feb 2014 11:41:34 -0600
Message-ID: <CAL_JsqL6YDcZJa5xziR7dP-bEt1CO4BtL1vsO8Qm+hFwgCiQ1w@mail.gmail.com>
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

On Wed, Feb 5, 2014 at 10:18 AM, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com> wrote:
>
> On 02/05/2014 04:39 PM, Rob Herring wrote:
>>
>> On Wed, Feb 5, 2014 at 7:47 AM, Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> wrote:
>>>
>>> This patch provides bindings for the 64-bit timer in the KeyStone
>>> architecture devices. The timer can be configured as a general-purpose
>>> 64-bit
>>> timer, dual general-purpose 32-bit timers. When configured as dual 32-bit
>>> timers, each half can operate in conjunction (chain mode) or
>>> independently
>>> (unchained mode) of each other.
>>
>> This is software configurable or h/w design time configurations?
>>
>> Rob
>>
>
> This is h/w design time configurations

Then it seems like the binding should provide for describing those
differences either with a property or different compatible strings.

Rob
