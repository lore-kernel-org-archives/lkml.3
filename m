Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbbABRxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:53:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39293 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbbABRxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:53:14 -0500
Message-ID: <54A6DAE8.90609@ti.com>
Date: Fri, 2 Jan 2015 11:52:40 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Santosh <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 0/2] ARM: l2c: OMAP4/AM437x: Additional register programming
 support.
References: <1420219072-6521-1-git-send-email-nm@ti.com> <20150102173859.GE3298@atomide.com>
In-Reply-To: <20150102173859.GE3298@atomide.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2015 11:38 AM, Tony Lindgren wrote:
> * Nishanth Menon <nm@ti.com> [150102 09:20]:
>> Hi,
>>
>> OMAP4 and AM437x ROM code provides services to program PL310's latency
>> registers and AM437x provides service for programming Address filter
>> registers.
>>
>> Provide support in the kernel for the same.
>>
>> This provides some support to the series: http://marc.info/?l=linux-arm-kernel&m=141933190912495&w=2
> 
> Are these to be applied before Thomasz's series as fixes? If we
> don't need these as fixes for the -rc, then probably makes sense
> for RMK to merge them all together for v3.20.
> 
These dont need to go in fixes. Can easily wait till 3.20. Thomaz
series wont exercise these path by default until someone modifies the
DT properties. Yes, will be nice to have them along with other changes
in v3.20. just for the record, i made a couple of typos in v1 of this
series and have updated a retested v2 of the series.


-- 
Regards,
Nishanth Menon
