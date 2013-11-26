Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3KZBlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:41:10 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38632 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3KZBlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:41:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131119135654.GL5914@e106331-lin.cambridge.arm.com>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
	<1384800901-21711-2-git-send-email-tim.kryger@linaro.org>
	<20131119135654.GL5914@e106331-lin.cambridge.arm.com>
Date: Mon, 25 Nov 2013 17:41:06 -0800
Message-ID: <CAAYSxhr4RVifzxK_AFx9ju+Sp2j_PUsg+Be1xAHQ_HTopbJ8Hg@mail.gmail.com>
Subject: Re: [PATCH 1/5] Documentation: dt: Add kona-pwm binding
From: Tim Kryger <tim.kryger@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
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

On Tue, Nov 19, 2013 at 5:56 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Nov 18, 2013 at 06:54:57PM +0000, Tim Kryger wrote:

>> +Required Properties :
>> +- compatible: should be "brcm,kona-pwm"
>> +- reg: physical base address and length of the controller's registers
>> +- clocks: clock specifier for the kona pwm external clock
>
> Minor nit: phandle + clock-specifier pair

I will incorporate this change into my next version.  Thanks.

-Tim
