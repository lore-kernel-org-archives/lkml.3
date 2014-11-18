Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaKRSEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:04:40 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60575 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKRSEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:04:39 -0500
Date: Tue, 18 Nov 2014 18:04:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 2/3] ARM: enable TTBR0/TTBR1 split in short mode
Message-ID: <20141118180418.GN28279@e104818-lin.cambridge.arm.com>
References: <20141118165313.9958.1242.stgit@buzz>
 <20141118165319.9958.67009.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118165319.9958.67009.stgit@buzz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:53:19PM +0000, Konstantin Khlebnikov wrote:
> This feature was partially implemented long time ago. All cpus load
> swapper_pg_dir into TTBR1 since commit d427958a46af24f75d0017c45eadd172273bbf33
> ("ARM: 6942/1: mm: make TTBR1 always point to swapper_pg_dir on ARMv6/7").
> But TTBRx split is never been enabled in TTBCR.

I recall there is an erratum on Cortex-A9 around the use of TTBR1 and at
the time that stopped me from pushing such change.

-- 
Catalin
