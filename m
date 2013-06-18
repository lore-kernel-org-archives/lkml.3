Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3FRMyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:54:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54598 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3FRMym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:54:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: irqchip: add support for MOXA ART SoCs
Date: Tue, 18 Jun 2013 14:54:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, tglx@linutronix.de
References: <1371549584-7169-1-git-send-email-jonas.jensen@gmail.com> <20130618103534.GW2718@n2100.arm.linux.org.uk>
In-Reply-To: <20130618103534.GW2718@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306181454.04011.arnd@arndb.de>
X-Provags-ID: V02:K0:7tM83bgjyZoJEAJPTa5wNjUOtKkARWXTkU+sV9g/grU
 fKOHGRZ9P5IMfI8Y3PgCSXsn/ZRlms8EVzlXG/817wQ4h+nDjF
 XGWuBCbCM2F0Mj8UR6ljJRIDV2TNiYFYVc8vpoZfjL7IBf+dBS
 XiiSRhTBFdnxoHYlSiuiE+WiQXkwCsY+tbJpCgA2ZAGL9kYucf
 cNcrwkRTWW2pfmLP2svgCWhT76qH4r1XdVMc+P+vBt0QGwgP1U
 EmMskQitrPoO1WawfqM13reKzcgzFHIQUYuuCdWzz8zQoXMmJh
 YQEfJ3e/Nqnu/2dxDghUHDK/xmY6BTrb5kZbEgtnAWla7A9011
 2DiyAsV7GTD+Pwp6zzN8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 June 2013, Russell King - ARM Linux wrote:
> Is there a reason this isn't using the irq_chip_generic stuff which would
> eliminate all the above?

When I first reviewed the moxart code, the generic irqchip wasn't compatible
with the linear irq domain. However this has changed now and it should indeed
use that.

	Arnd
