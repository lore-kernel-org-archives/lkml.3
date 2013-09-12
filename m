Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3ILUEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:04:22 -0400
Received: from vps1.hno.se ([31.192.227.87]:38978 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab3ILUET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:04:19 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 16:03:06 EDT
Message-ID: <1379015615.21661.0.camel@localhost>
Subject: Re: [linux-sunxi] Re: [PATCH 4/4] Add arch count timer node in dts
 for Allwinner A20(sunxi 7i).
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: linux-sunxi@googlegroups.com
Cc: Ian Campbell <ijc@hellion.org.uk>, "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Date: Thu, 12 Sep 2013 21:53:35 +0200
In-Reply-To: <CAK3cCByUJG42D6w4e1tdnXY0TQ517yOjQxFZJEnsyS4d0bxZyQ@mail.gmail.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
	 <1378968687-8200-5-git-send-email-cinifr@gmail.com>
	 <20130912145756.GD22013@e106331-lin.cambridge.arm.com>
	 <1379000686.10076.76.camel@kazak.uk.xensource.com>
	 <CAK3cCByUJG42D6w4e1tdnXY0TQ517yOjQxFZJEnsyS4d0bxZyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fre 2013-09-13 klockan 00:23 +0800 skrev cinifr:

> Yes, My bootloader dont set it, and I have to set it at  dtsi  fot
> boot, I found <clock-frequency> is be set in dtsi file for ohters
> cups.

The patch from Ian is now in sunxi u-boot.

Regards
Henrik


