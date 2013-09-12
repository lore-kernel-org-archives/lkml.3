Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3ILQI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:08:26 -0400
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:57692 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3ILQIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:08:25 -0400
Message-ID: <1379000355.10076.75.camel@kazak.uk.xensource.com>
Subject: Re: [linux-sunxi] Re: [PATCH 3/4] Add physical count arch timer
 support for clocksource in ARMv7.
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
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Andre Przywara <andre.przywara@linaro.org>
Date: Thu, 12 Sep 2013 16:39:15 +0100
In-Reply-To: <20130912112452.GA22013@e106331-lin.cambridge.arm.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
	 <1378968687-8200-4-git-send-email-cinifr@gmail.com>
	 <20130912112452.GA22013@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 12:24 +0100, Mark Rutland wrote:
> 
> Why can the bootloader not be fixed to set CNTVOFF (or to boot the
> kernel in Hyp mode)? 

It can:
http://lists.xen.org/archives/html/xen-devel/2013-09/msg00880.html

I was waiting for Andre's hyp mode u-boot patches to land before posting
the sunxi bits on top. I'm not sure what the status of that is.

Ian.

