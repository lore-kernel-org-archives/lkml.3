Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaAOQjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:39:41 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34575 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbaAOQji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:39:38 -0500
Date: Wed, 15 Jan 2014 16:39:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sherman Yin <syin@broadcom.com>, Mark Brown <broonie@kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/4] pinctrl: Add pinctrl binding for Broadcom Capri
 SoCs
Message-ID: <20140115163932.GI25824@e106331-lin.cambridge.arm.com>
References: <1386787041-6035-1-git-send-email-syin@broadcom.com>
 <1387592016-13740-1-git-send-email-syin@broadcom.com>
 <1387592016-13740-3-git-send-email-syin@broadcom.com>
 <CACRpkdaAq15wKD900SqN1sQFLBATiuA3vNoua+KJGHU+gdCgqg@mail.gmail.com>
 <52CC6782.4060309@broadcom.com>
 <CACRpkdYyz+zrzt0y135Wcq-yUMhiHOb1ov15+SsnVOcZvad96g@mail.gmail.com>
 <52D5896B.6000209@broadcom.com>
 <CACRpkdYCmMguUPFRAUHf186_ciKcchBZLGfgqn_VcSMiZi+a8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYCmMguUPFRAUHf186_ciKcchBZLGfgqn_VcSMiZi+a8Q@mail.gmail.com>
Thread-Topic: [PATCH v4 2/4] pinctrl: Add pinctrl binding for Broadcom
 Capri SoCs
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Jan 15, 2014 at 09:40:53AM +0000, Linus Walleij wrote:
> On Tue, Jan 14, 2014 at 8:00 PM, Sherman Yin <syin@broadcom.com> wrote:
> 
> > Great!  Is there anything else you would like to see changed before this
> > patchset can be accepted?
> 
> I'd like some sign of life from the DT binding maintainers.

Let's check the electrocardiogram...

           _             _          _        _        _
__________/ \   ________/ \   _____/ \   ___/ \   ___/ \   __
             \_/           \_/        \_/      \_/      \_/


I don't see anything objectionable in the binding.

Linus, if you think that this binding is sane, feel free to add my ack.

Cheers,
Mark.
