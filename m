Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaH3H5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 03:57:53 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65386 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaH3H5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 03:57:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] MIPS: GIC: Move MIPS_GIC_IRQ_BASE into platform irq.h
Date: Sat, 30 Aug 2014 09:57:33 +0200
Message-ID: <6179185.bNbDBEC6tl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409350479-19108-5-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org> <1409350479-19108-5-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Ky9RecbHG1JaYrCgDcQvPDSF8IWkvlCGQNDPah6GsMJ
 ACSMbzSwSLMfvWrp9nkBizUeJRpjOp6k3KPJzqu8Dfy+m0VyvR
 /IgZqmHST5y8n4bgUS9wLsZDeRsnSbIGiZkKPjEXPJR9IYEhXv
 uECr0sCIEbp8XWsRP/CeWxAYYRo4GpHf25LbYo7V4p0piN0lbB
 gqPfnEs4GKL8TLk9VEEIN63JwVl4UKWk6+OFUNmz7QRele+d4s
 l0B251yrwCQxqRO2r3EmD2+cve87o4aVbuq59zdOhqzL+59KPJ
 HuvCh0bESlqGFHI56yV81h1vEp8G9USQoGd2mg/APcfNGGQ/7U
 7MFyCbnEQlD4DZnBI47o=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2014 15:14:31 Andrew Bresticker wrote:
> Define a generic MIPS_GIC_IRQ_BASE which is suitable for Malta and
> the upcoming Danube board in <mach-generic/irq.h>.  Since Sead-3 is
> different and uses a MIPS_GIC_IRQ_BASE equal to the CPU IRQ base (0),
> define its MIPS_GIC_IRQ_BASE in <mach-sead3/irq.h>.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> 

Why do you actually have to hardwire an IRQ base? Can't you move
to the linear irqdomain code for DT based MIPS systems yet?

	Arnd
