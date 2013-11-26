Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3KZBun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:50:43 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36666 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3KZBui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <20131125111709.GJ22043@ulmo.nvidia.com>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
	<1384800901-21711-2-git-send-email-tim.kryger@linaro.org>
	<20131125111709.GJ22043@ulmo.nvidia.com>
Date: Mon, 25 Nov 2013 17:50:38 -0800
Message-ID: <CAAYSxho=vJ0svnsg4KkD7tU9JMekEwef3if2jJD=d5pwWwndMw@mail.gmail.com>
Subject: Re: [PATCH 1/5] Documentation: dt: Add kona-pwm binding
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 3:17 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Nov 18, 2013 at 10:54:57AM -0800, Tim Kryger wrote:

>> +++ b/Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
>> @@ -0,0 +1,24 @@
>> +Broadcom's PWM Controller Device Tree bindings
>
> This sounds somewhat strange, like Broadcom owns the bindings... perhaps
> just:
>
>         Broadcom PWM controller device tree bindings
>
> Or for consistency:
>
>         Broadcom Kona PWM controller device tree bindings

Yes that sounds better.

>> +Broadcom's Kona PWM Controller has 6 channels
>
> "controller" and end the sentence with a full stop.

Sure.

>> +- clocks: clock specifier for the kona pwm external clock
>
> Please use the correct spelling "PWM" in prose here and elsewhere. Also
> you should pick one of "kona", "Kona" or "KONA" and stick with it
> consistently. Might also be useful to mention what Kona is. Doesn't
> necessarily have to be in the document, but if for nothing else, then
> just for my curiosity.

Agreed.  It should be "Kona" here.

Kona roughly defines the set of common IP used on multiple mobile SoCs.

>> +- #pwm-cells: should be 2.  The first cell specifies the per-chip index
>> +  of the PWM to use and the second cell is the period in nanoseconds.
>> +
>> +Refer to pwm/pwm.txt for generic pwm controller node properties.
>> +
>> +Refer to clocks/clock-bindings.txt for generic clock consumer
>> +properties
>
> This sentence should also end with a full stop.

Sure thing.  Thanks again.

-Tim
