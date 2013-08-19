Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902Ab3HSIEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:04:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3HSIEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:04:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [RFC v1 0/5] ARM: Initial support for Marvell Armada 1500
Date: Mon, 19 Aug 2013 10:03:39 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <201308172132.59402.arnd@arndb.de> <521156EF.3090201@gmail.com>
In-Reply-To: <521156EF.3090201@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308191003.39528.arnd@arndb.de>
X-Provags-ID: V02:K0:bHsy+il8jvzMsiV61BTT0zw5gHw08GMA+WQ9yXNuSRY
 Z3AwBmcVWJB23aE46FV+yAHoOsZ80Xekkt5ds7l8bUSBgN/GvT
 dTdkDi5odtdb9jeuZXwoI/Q/TsX/DoxaECjAywlE6XTe2ci3Te
 FopK6by0fatOjfjywxcJSt8YWq22n93u2TI4R3Gm5f/ugdQIqf
 uGliz5CESzC91EOB3TMfb0S/6bgNiJvRl7Z54dSuX0CgTqAvr9
 NOWayIsFm2av279ElnIwC3njukvJuVUQi+WaQvJKDCwWJ10uw+
 IO6SyUwC45/KOqVC3LAW/m0TA4rdUKVxBet2+Y6bVme4/aHBVZ
 VPTBGa41A0OqHeeThLLk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 August 2013, Sebastian Hesselbarth wrote:
> We either put it into mach-mvebu and pretend to consolidate Marvell SoCs
> in there. Pro would be that it is close to other Armadas there, con is
> that Armada is codename for virtually any Marvell SoC lately.
> 
> If we want a new mach- directory, I'd suggest either mach-berlin which
> looks like some nickname for 88de3xxx SoCs or simply boring
> mach-88de3xxx.

As I said, either way is fine with me. If you use a new directory, I'd
suggest using the same mach-mv88de3100 name that Marvell uses, to give
them a "hint" about this when updating their own sources to a newer
version. They might get the idea and actually start using your code ;-)

	Arnd
