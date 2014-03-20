Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbaCTTyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:54:49 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:53192 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759230AbaCTTyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:54:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140320155732.GB25092@ulmo>
References: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
	<1394655346-30048-3-git-send-email-tim.kryger@linaro.org>
	<20140318215231.GH5917@mithrandir>
	<CAAYSxhri0evgrbCPew6-MTXVmpzm7Oa6TpmJTSGZpTcV=876HQ@mail.gmail.com>
	<20140320155732.GB25092@ulmo>
Date: Thu, 20 Mar 2014 12:54:46 -0700
Message-ID: <CAAYSxhothsZp6k2pKnA4XdTKf06+_rw95GPGJqRb2=xP6gJPNQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] pwm: kona: Introduce Kona PWM controller support
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 8:57 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Tue, Mar 18, 2014 at 04:47:36PM -0700, Tim Kryger wrote:
>> On Tue, Mar 18, 2014 at 2:52 PM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>> > On Wed, Mar 12, 2014 at 01:15:43PM -0700, Tim Kryger wrote:

>> >> +     tristate "Kona PWM support"
>> >> +     depends on ARCH_BCM_MOBILE
>> >> +     default y
>> >
>> > No "default y", please.
>>
>> Even though it depends on ARCH_BCM_MOBILE?  It seems like a reasonable
>> default.
>
> Well, that's only true until somebody decides to turn that dependency
> into something like:
>
>         depends on ARCH_BCM_MOBILE || COMPILE_TEST

Do you expect someone would actually make such a change?

>
>> These SoCs target mobile phones which almost always have a backlight
>> controlled by the PWM.
>
> And you can easily turn it on in bcm_defconfig and/or multi_v7_defconfig
> if you want it enabled "by default".

Except that is not what default means.

Having a sensible default value in the Kconfig is convenient and
enables savedefconfig to create minimal configuration files.

Are you firmly opposed to this?

Thanks Again,
Tim
