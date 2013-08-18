Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3HRQed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 12:34:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52375 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753299Ab3HRQeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 12:34:31 -0400
Date: Sun, 18 Aug 2013 18:34:21 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 0/5] ARM: Initial support for Marvell Armada 1500
Message-ID: <20130818183421.724eb404@skate>
In-Reply-To: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Fri, 16 Aug 2013 21:41:33 +0200, Sebastian Hesselbarth wrote:
> This is a RFC adding initial support for the Marvell Armada 1500
> (88DE3100) found on various consumer devices (Chromecast, GoogleTV).

Nice!

> Actually, it is a two-fold RFC also raising discussions on mach-mvebu
> cleanup roadmap to allow other SoCs to hop into it. While mach-mvebu
> originally was created to add support for Armada 370/XP and merge
> existing Marvell Orion familiy into it, I am not so sure about
> Armada 1500 fits that well (the mbus has gone!).

Technically speaking, the Armada 1500 is not designed by the EBU
division of Marvell (that does the Orion, Kirkwood, Armada 370/XP SOCs),
so having it under mach-mvebu may sound a little bit strange. However,
I don't yet have a clear vision of how much different the platform code
will be, especially since the platform code tends to get smaller and
smaller due to the move of lots of code to drivers/.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
