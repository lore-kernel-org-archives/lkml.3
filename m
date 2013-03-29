Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3C2Md1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 08:33:27 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51607 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754572Ab3C2Md0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 08:33:26 -0400
Message-ID: <1364560405.1345.67.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: davinci: remove test for undefined Kconfig macro
From: Paul Bolle <pebolle@tiscali.nl>
To: Sekhar Nori <nsekhar@ti.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 13:33:25 +0100
In-Reply-To: <1364557655.1345.58.camel@x61.thuisdomein>
References: <1364557655.1345.58.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2013 12:33:25.0320 (UTC) FILETIME=[9B94AC80:01CE2C79]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dropped Kevin Hilman, because Kevin's address bounces.]

On Fri, 2013-03-29 at 12:47 +0100, Paul Bolle wrote:
> The DaVinci debugging macro contains a check for
> CONFIG_DEBUG_DAVINCI_DA8XX_UART0. But there's corresponding Kconfig

                                  [...] there's no corresponding [...]

> symbol, so this test will always evaluate to false. That Kconfig symbol
> is not needed because, as __arch_decomp_setup() shows, there are no
> DaVinci DA8XX boards that use UART0 for debugging. We can remove two
> lines of unneeded code.


Paul Bolle

