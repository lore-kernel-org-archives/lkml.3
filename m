Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbaLWVId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:08:33 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:49598 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaLWVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:08:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@linaro.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, yh.chen@mediatek.com,
        Robert Richter <rrichter@cavium.com>, srv_heupstream@mediatek.com,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2 3/4] arm64: dts: Add mediatek MT8173 SoC and  evaluation board dts and Makefile
Date: Tue, 23 Dec 2014 22:07:45 +0100
Message-ID: <1947751.D0rZorCFoT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <72aa7f4069a000c6e39c53e328015aa3@www.loen.fr>
References: <1418825853-10934-1-git-send-email-eddie.huang@mediatek.com> <1419321723.14341.38.camel@mtksdaap41> <72aa7f4069a000c6e39c53e328015aa3@www.loen.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:PPcszdZ0qS8U2jUOgA/pocb8PX1rfSALwvpgH/UuuRff71CFA8t
 1knGNQE8JZjzmiD13GyTk7+1ZZvMc7grcEkqcVo29VvUHnhvhJLzKV3mZ1ugzSb3/k+YXOb
 BJNBy7KTOJgzIh+z9yzkA5grBHFm7BZuS8bE597qNqvq9BF0sj5Zg2wDtSJKnNwBQGZVout
 md0Sbuv7ORsn0sEYsH2CA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2014 08:43:55 Marc Zyngier wrote:
> 
> > Neverthless, MT8173 SoC already use 0x10224000 and 0x10225000 as VGIC
> > base address.
> 
> Then its fate is sealed virtualization wise.

It should still work with 4kb pages on the host, right? Would that still
allow you to have 64kb pages on the guest, or does the guest page size
have to be smaller or equal to the host?

	Arnd
