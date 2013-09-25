Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3IYKjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:39:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37679 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753371Ab3IYKjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:39:08 -0400
Date: Wed, 25 Sep 2013 07:39:03 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Jean Pihet <jean.pihet@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, john.stultz@linaro.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] arm: mvebu: use the main timer as clock source from DT
Message-ID: <20130925103902.GA2418@localhost>
References: <1379530168-9359-1-git-send-email-jean.pihet@linaro.org>
 <20130918185611.GP19937@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130918185611.GP19937@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 02:56:11PM -0400, Jason Cooper wrote:
> Adding clocksource maintainers to the Cc: ...
> 
> On Wed, Sep 18, 2013 at 08:49:28PM +0200, Jean Pihet wrote:
> > This commit:
> >   573145f08c2b92c45498468afbbba909f6ce6135
> >   clocksource: armada-370-xp: Use CLOCKSOURCE_OF_DECLARE
> > 
> > replaced a call to the driver's timer initialization by a call to
> > clocksource_of_init(). However, it failed to select CONFIG_CLKSRC_OF.
> > 
> > Fix this by selecting CONFIG_CLKSRC_OF for Armada370/XP machines.
> > Without this change the kernel is stuck at: 'Calibrating delay loop...'.
> > 
> > Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> > Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > ---
> >  drivers/clocksource/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> 
> Daniel, John, Thomas,
> 
> Can you queue this up for v3.12-rc2?  It fixes a boot breakage.
> 

Is this already merged somewhere? Is there any chance we can push
it through *any* tree so it makes -rc3?

Thanks,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
