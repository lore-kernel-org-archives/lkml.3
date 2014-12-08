Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaLHQDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:03:34 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46386 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbaLHQDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:03:32 -0500
Date: Mon, 8 Dec 2014 16:03:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        Arend Van Spriel <arend@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: using DMA-API on ARM
Message-ID: <20141208160316.GM16185@e104818-lin.cambridge.arm.com>
References: <5481794E.4050406@broadcom.com>
 <F51492713EF10846800D8C0ED37A7DCE01901765@SJEXCHMB15.corp.ad.broadcom.com>
 <F51492713EF10846800D8C0ED37A7DCE01902076@SJEXCHMB15.corp.ad.broadcom.com>
 <2863746.4sUSEYqahB@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2863746.4sUSEYqahB@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 03:01:32PM +0000, Arnd Bergmann wrote:
> [    0.000000] PL310 OF: cache setting yield illegal associativity
> [    0.000000] PL310 OF: -1069781724 calculated, only 8 and 16 legal
> [    0.000000] L2C-310 enabling early BRESP for Cortex-A9
> [    0.000000] L2C-310 full line of zeros enabled for Cortex-A9
> [    0.000000] L2C-310 dynamic clock gating enabled, standby mode enabled
> [    0.000000] L2C-310 cache controller enabled, 16 ways, 256 kB
> [    0.000000] L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x4e130001

If the above value is correct, they should make sure bit 22 is set in
AUX_CTRL.

-- 
Catalin
