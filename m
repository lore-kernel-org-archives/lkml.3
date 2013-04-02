Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913Ab3DBKIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:08:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47609 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759807Ab3DBKIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:08:42 -0400
Message-ID: <515AAE16.4080200@ti.com>
Date: Tue, 2 Apr 2013 15:38:22 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] ARM: davinci: remove test for undefined Kconfig macro
References: <1364557655.1345.58.camel@x61.thuisdomein> <1364560405.1345.67.camel@x61.thuisdomein>
In-Reply-To: <1364560405.1345.67.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/2013 6:03 PM, Paul Bolle wrote:
> [Dropped Kevin Hilman, because Kevin's address bounces.]

Use khilman@deeprootsystems.com as updated in MAINTAINERS.

> 
> On Fri, 2013-03-29 at 12:47 +0100, Paul Bolle wrote:
>> The DaVinci debugging macro contains a check for
>> CONFIG_DEBUG_DAVINCI_DA8XX_UART0. But there's corresponding Kconfig
> 
>                                   [...] there's no corresponding [...]
> 
>> symbol, so this test will always evaluate to false. That Kconfig symbol
>> is not needed because, as __arch_decomp_setup() shows, there are no
>> DaVinci DA8XX boards that use UART0 for debugging. We can remove two
>> lines of unneeded code.

Queuing this for v3.10 with updated commit text indicated above.

Thanks,
Sekhar
