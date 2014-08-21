Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaHUCkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:40:42 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60120 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaHUCki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:40:38 -0400
X-CheckPoint: {53F55C1B-0-2100090A-C0000000}
From: Tony Lu <zlu@tilera.com>
To: Pranith Kumar <bobby.prani@gmail.com>, Vineet Gupta <vgupta@synopsys.com>,
        Richard Kuo <rkuo@codeaurora.org>, Chris Metcalf <cmetcalf@tilera.com>,
        "Chris Zankel" <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Noam Camus <noamc@ezchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Kirill Tkhai <tkhai@yandex.ru>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QUALCOMM HEXAGON..." <linux-hexagon@vger.kernel.org>,
        "open list:SUPERH" <linux-sh@vger.kernel.org>,
        "open list:TENSILICA XTENSA..." <linux-xtensa@linux-xtensa.org>
Subject: RE: [PATCH v2] flush_icache_range: Export symbol to fix build errors
Thread-Topic: [PATCH v2] flush_icache_range: Export symbol to fix build
 errors
Thread-Index: AQHPuv10MipVopSHEU+4WB2NEqTpJpvaWuJA
Date: Thu, 21 Aug 2014 02:40:26 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D78D05E@USMAExch1.tad.internal.tilera.com>
References: <1408377559-30775-1-git-send-email-bobby.prani@gmail.com>
In-Reply-To: <1408377559-30775-1-git-send-email-bobby.prani@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.200.0.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>Fix building errors occuring due to a missing export of flush_icache_range()
>in
>
>kisskb.ellerman.id.au/kisskb/buildresult/11677809/
>
>ERROR: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!
>
>Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>CC: Andrew Morton <akpm@linux-foundation.org>
>---
> arch/arc/mm/cache_arc700.c | 1 +
> arch/hexagon/mm/cache.c    | 1 +
> arch/sh/mm/cache.c         | 1 +
> arch/tile/kernel/smp.c     | 1 +
> arch/xtensa/kernel/smp.c   | 1 +
> 5 files changed, 5 insertions(+)
>

For Tile,

Acked-by: Zhigang Lu <zlu@tilera.com>
