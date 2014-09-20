Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbaITCHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 22:07:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:33385 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbaITCHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 22:07:33 -0400
Date: Fri, 19 Sep 2014 21:07:06 -0500 (CDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Lindgren <tony@atomide.com>
cc: Nishanth Menon <nm@ti.com>, lee.jones@linaro.org,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-omap@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V3 3/3] mfd: palmas: Add support for optional wakeup
In-Reply-To: <20140919195738.GR14505@atomide.com>
Message-ID: <alpine.DEB.2.10.1409192100380.23826@nanos>
References: <1411067086-16613-1-git-send-email-nm@ti.com> <1411067086-16613-4-git-send-email-nm@ti.com> <alpine.DEB.2.10.1409181749170.4206@nanos> <20140919030333.GA6088@kahuna> <alpine.DEB.2.10.1409190710320.5612@nanos> <20140919161927.GA28613@kahuna>
 <alpine.DEB.2.10.1409191027330.5612@nanos> <20140919191649.GQ14505@atomide.com> <alpine.DEB.2.10.1409191233590.4213@nanos> <20140919195738.GR14505@atomide.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014, Tony Lindgren wrote:
> * Thomas Gleixner <tglx@linutronix.de> [140919 12:47]:
> > Why on earth are you wanting tasklets in there? That's just silly,
> > really.
> 
> Lack of a framework on driver side to cope with this in a generic
> way? :p

So instead of creating such a thing we rather have a completely ass
backward workaround which spreads itself all over the tree?

You SoC folks really need a quarterly sanity check.

Thanks,

	tglx
