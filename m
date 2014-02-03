Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaBCPco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:32:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBCPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:32:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 09/10] watchdog: xilinx: Add missing binding
Date: Mon, 03 Feb 2014 16:32:25 +0100
Message-ID: <3121595.GbLMuGPlvA@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <24ecacca-2714-4834-921c-b827c0e592a3@VA3EHSMHS003.ehs.local>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <201402031606.11753.arnd@arndb.de> <24ecacca-2714-4834-921c-b827c0e592a3@VA3EHSMHS003.ehs.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wOi6G2Gih/Y9GtxT/pmComfbWOl8se+5HvcFiE/O9D+
 f5eXzhwQ1gnNaYjPHfg3wh4AhLL9bV/wC4/2FTJP/2iK6ENZ/d
 zoniGXivwqz/NX79kCRCYFhHQieIb/pwPeHOyib6J6PfGGU3LR
 KUHgowZ68O+UIUwYywnBg0mRA2AhEjsLENMwObaf/Oz0Ud5Dsy
 fHMQ/sKWsIyvhbI2DyJXvs1IoZ06qXcMz5zDw9OmBdBh/znI4Z
 xBTyN8vT6cnHdesJNcYiDhs7BNUA8ye0ij4sN8BMFPw8Ml+qbA
 ussc8IscmaWVjuf3wPftETfHvat841vzhcRLBGDY0sgDCiVQWA
 uzx10t2jT6IwptiIPg+M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014 16:13:47 Michal Simek wrote:
> Intention wasn't to fix binding but document current one
> which is in mainline for a long time.

Ok, I see.

> Apart of this - yes, wdt-enable-once is nowayout and wdt-interval should be timeout
> is seconds, and clock-frequency should go out and use CCF for getting clock.

Could we make a common binding then, and document that the xilinx
watchdog can optionally provide either one?

	Arnd
