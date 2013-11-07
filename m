Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3KGQVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:21:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3KGQVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:21:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 9/9] ARM: add initial support for Marvell Berlin SoCs
Date: Thu, 7 Nov 2013 17:20:47 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jisheng Zhang <jszhang@marvell.com>, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131107134033.59bd127a@xhacker> <527B67A1.3020803@gmail.com>
In-Reply-To: <527B67A1.3020803@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311071720.47489.arnd@arndb.de>
X-Provags-ID: V02:K0:FmHxNZDNUrc6M1fHYD7rJfI482g1cuidNPvc3OZ0Iwf
 ExaLs8Q39cXtDgbbGqFqBTpL7FI9b9bjJtZbd5/AeCrS4bkh3a
 AAZp/z7g8dgWy855eEEtL5ABbr45A625vEiOLI+2+VT9TtcHXe
 6zEwkl31II1ryQT+6PSpLDdybQJk9sqqSKMNIdAvw+rZYFZn1p
 8E2ix1xSmQMllw15zn07jSukCC5Kv3jh5ac317cG9kQs/70hVH
 +ixFKXG5AKhLcpaek73FIEBRkBbZX5b/5JdaQZMUhiX3A32bCx
 l6d6Y9bkifIfIQgQI5/WNVtHXaP8kD0lovQZcjhuu/41yC74EB
 FYki8Xe82+dzdZ2JrfCI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 November 2013, Sebastian Hesselbarth wrote:
> Actually, IIRC smp_twd does not compile without SMP set, so the above
> should at least be 'HAVE_ARM_TWD if SMP'. If you shrink MULTI_V7 down
> to non-SMP cores, you can disable it and it will fail to compile.
> 

If there are UP-systems for which TWD is the best clocksource, we should
probably fix the code to allow that configuration. IIRC there were already
patches recently in this area, maybe it's already solved.

	Arnd
