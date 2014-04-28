Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbaD1PUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:20:04 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59374 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaD1PTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:19:54 -0400
Date: Mon, 28 Apr 2014 11:19:49 -0400
From: Matt Porter <mporter@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 RESEND 0/5] Add Broadcom Kona PWM Support
Message-ID: <20140428151949.GD7719@beef>
References: <1398450675-19609-1-git-send-email-tim.kryger@linaro.org>
 <20140428110731.GH19455@ulmo>
 <CAAYSxhpOP78EQAM0cWM2RwLu29-0eRVgLCFX3Hob8q=J==5wUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYSxhpOP78EQAM0cWM2RwLu29-0eRVgLCFX3Hob8q=J==5wUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 08:00:39AM -0700, Tim Kryger wrote:
> On Mon, Apr 28, 2014 at 4:07 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Fri, Apr 25, 2014 at 11:31:10AM -0700, Tim Kryger wrote:
> >> This series introduces the driver for the Kona PWM controller found in
> >> Broadcom mobile SoCs like bcm281xx and updates the device tree and the
> >> defconfig to enable use of this hardware on the bcm28155 AP board.
> >>
> 
> >> Tim Kryger (5):
> >>   Documentation: dt: Add Kona PWM binding
> >>   pwm: kona: Introduce Kona PWM controller support
> >>   ARM: dts: Declare the PWM for bcm11351 (bcm281xx)
> >>   ARM: dts: Enable the PWM for bcm28155 AP board
> >>   ARM: bcm_defconfig: Enable PWM and Backlight
> 
> > I've applied patches 1 and 2 (with two tiny whitespace cleanups) to my
> > for-next branch.
> 
> Sounds good.  Thank you.
> 
> Matt and Christian, are you okay taking patches 3-5 through your tree?

Yes, I've now applied them to the appropropriate mach-bcm 3.16 branches.

-Matt
