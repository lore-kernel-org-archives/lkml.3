Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaCNNnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:43:32 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36534 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaCNNn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:43:29 -0400
Date: Fri, 14 Mar 2014 09:43:24 -0400
From: Matt Porter <mporter@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [PATCH v3 0/5] Add Broadcom Kona PWM Support
Message-ID: <20140314134324.GY25092@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394655346-30048-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:15:41PM -0700, Tim Kryger wrote:
> This series introduces the driver for the Kona PWM controller found in
> Broadcom mobile SoCs like bcm281xx and updates the device tree and the
> defconfig to enable use of this hardware on the bcm28155 AP board.
> 
> Changes since v2:
>   - SoC DTS file updated to use real clock's phandle + specifier
>   - Toggle smooth mode off during apply so new settings take immediately
> 
> Changes since v1:
>   - Fixed up macros to be clearer and more complete
>   - Corrected spelling and punctuation mistakes
>   - Added support for polarity
>   - Made peripheral clock use more efficient
>   - Made prescale and duty computation clearer
>   - Moved Makefile addition to keep alphabetical
>   - Split complex lines into multiple steps
> 
> Dependencies:
> The "ARM: dts: Declare the PWM for bcm11351 (bcm281xx)" patch depends
> upon "ARM: dts: bcm281xx: define real clocks" which is queued up in
> for-next of arm-soc. See https://lkml.org/lkml/2014/2/14/451
> 
> Tim Kryger (5):
>   Documentation: dt: Add Kona PWM binding
>   pwm: kona: Introduce Kona PWM controller support

Thierry, are you planning to merge these first two for 3.15? If so, I
will apply dts patches for my last mach-bcm 3.15 pull. I don't want to
do so until the binding is accepted.

-Matt

>   ARM: dts: Declare the PWM for bcm11351 (bcm281xx)
>   ARM: dts: Enable the PWM for bcm28155 AP board
>   ARM: bcm_defconfig: Enable PWM and Backlight
