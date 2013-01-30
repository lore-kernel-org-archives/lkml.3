Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3A3TTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:19:49 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:33130 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755198Ab3A3TTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:19:48 -0500
Date: Wed, 30 Jan 2013 20:19:45 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Takahisa Tanaka <mc74hc00@gmail.com>
Cc: linux-watchdog@vger.kernel.org,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH 1/2] sp5100_tco: Fix wrong indirect I/O access for getting value of reserved bits
Message-ID: <20130130191945.GA20100@spo001.leaseweb.com>
References: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358128918-4415-1-git-send-email-mc74hc00@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> In case of SB800 or later chipset and re-programming MMIO address(*),
> sp5100_tco module may read incorrect value of reserved bit, because the module
> reads a value from an incorrect I/O address. However, this bug doesn't cause
> a problem, because when re-programming MMIO address, by chance the module
> writes zero (this is BIOS's default value) to the low three bits of register.
> * In most cases, PC with SB8x0 or later chipset doesn't need to re-programming
>   MMIO address, because such PC can enable AcpiMmio and can use 0xfed80b00 for
>   watchdog register base address.
> 
> This patch fixes this bug.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
> Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>

Added to linux-watchdog-next.

Kind regards,
Wim.

