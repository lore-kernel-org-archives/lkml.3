Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3ILPox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:44:53 -0400
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:54691 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3ILPow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:44:52 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 11:44:52 EDT
Message-ID: <1379000686.10076.76.camel@kazak.uk.xensource.com>
Subject: Re: [linux-sunxi] Re: [PATCH 4/4] Add arch count timer node in dts
 for Allwinner A20(sunxi 7i).
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>, "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Date: Thu, 12 Sep 2013 16:44:46 +0100
In-Reply-To: <20130912145756.GD22013@e106331-lin.cambridge.arm.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
	 <1378968687-8200-5-git-send-email-cinifr@gmail.com>
	 <20130912145756.GD22013@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 15:57 +0100, Mark Rutland wrote:

> > +			interrupts = <1 13 0x308>,
> > +				     <1 14 0x308>,
> > +				     <1 11 0x308>,
> > +				     <1 10 0x308>;
> > +			clock-frequency = <24000000>;
> 
> If at all possible, your bootloader should set CNTFREQ, and
> clock-frequency should only be used as a last resort when it's
> impossible to get it to set CNTFREQ. It's not possible to set CNTFREQ
> from the non-secure side, so guests (which might not be Linux, and might
> not handle DT in the same way) may see a completely wrong frequency
> value.

https://groups.google.com/forum/#!topic/linux-sunxi/56Wj1IT-pKU

Ian.

