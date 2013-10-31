Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3JaGGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:06:20 -0400
Received: from 10.mo6.mail-out.ovh.net ([87.98.157.236]:58036 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752629Ab3JaGGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:06:19 -0400
X-Greylist: delayed 1805 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2013 02:06:18 EDT
Date: Thu, 31 Oct 2013 06:30:37 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] misc: atmel_pwm: set initcall level to subsys
Message-ID: <20131031053037.GA30542@ns203013.ovh.net>
References: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
 <20131029232249.GA20476@kroah.com>
 <20131030110705.GA29813@localhost>
 <201310302146.18248.arnd@arndb.de>
 <5271B012.4060200@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5271B012.4060200@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 16938319674227469107
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:19 Thu 31 Oct     , Bo Shen wrote:
> Hi Arnd,
> 
> On 10/31/2013 04:46, Arnd Bergmann wrote:
> >On Wednesday 30 October 2013, Johan Hovold wrote:
> >>>I really hate this type of patch, as it's papering over the real
> >>>problem.  What happens when someone else moves their driver to this
> >>>level?  Then you are back to the original problem.
> >>
> >>Yes, it's crude, but it's currently the only way to express a preferred
> >>probe order.
> >
> >Does the same problem occur with the generic PWM subsystem?
> >
> >The atmel_pwm driver apparently is the last PWM driver that has
> >not been converted to the generic subsystem yet. Doing that would
> >also let us drop the atmel-pwm-bl driver in favor of the generic
> >backlight.
> 
> The atmel pwm driver is on the way to generic subsystem. more
> information at:
> --->8---
> PWM: atmel-pwm: add PWM controller driver:
>    https://patchwork.kernel.org/patch/2963081/

so the fix can be drop in favor of the conversion

Best Regards,
J.
> ---<8---
> 
> Best Regards,
> Bo Shen
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
