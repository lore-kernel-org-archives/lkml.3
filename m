Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaLTUId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:08:33 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:52199 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaLTUI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:08:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Olof Johansson <olof@lixom.net>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH v2 3/4] arm64: dts: Add mediatek MT8173 SoC and evaluation board dts and Makefile
Date: Sat, 20 Dec 2014 21:07:53 +0100
Message-ID: <3669965.zfJEHTFEBI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54919AC9.2090306@arm.com>
References: <1418825853-10934-1-git-send-email-eddie.huang@mediatek.com> <20141217143305.GC8942@leverpostej> <54919AC9.2090306@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:1mMvIQ83PF3SLjMaBEApWiYnAq4i47cIAIXZtT8W2anaiud1GNB
 W7pdaoYfeArRb9rqcsHTGylxfqEsAvVdLdLY5hgRoJaa0rjJnJ7Ymfugj5kjS2obikVANiD
 /tYWlvGYGx0YWh7cBOMkpPrycElcDixV+4p/lTa+vxx5UE2TapOMRF2Y+og6QA3U8ooe2hX
 IWhL4RGUtZKHL2fVq66Tg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 15:01:29 Marc Zyngier wrote:
> 
> Indeed, as described in the documentation:
> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0471b/CHDIFAEE.html
> 
> Also it is worth noticing that given how GICV is placed, it will never
> work with 64K pages and virtualization. Pretty sad.

Does this mean no VGIC support on this platform so you have to emulate it
in order to run virtual machines with 64K pages, or does it mean that
it's impossible to use that way because you can't emulate it?

	Arnd
