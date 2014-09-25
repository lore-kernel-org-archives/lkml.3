Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaIYKOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:14:19 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:50809 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbaIYKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:14:18 -0400
Message-ID: <1411640056.7866.5.camel@x220>
Subject: Re: [PATCH] ARM: efm32: drop selecting NO_DMA
From: Paul Bolle <pebolle@tiscali.nl>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 25 Sep 2014 12:14:16 +0200
In-Reply-To: <1411585151.19525.29.camel@x220>
References: <1411585151.19525.29.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Sep 2014 10:14:16.0883 (UTC) FILETIME=[76A80830:01CFD8A9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 20:59 +0200, Paul Bolle wrote:
> Actually, the only difference I found in the .config file was that after
> this patch the .config file contained
>     CONFIG_ARCH_EFM32=y
> 
> I have no idea why. Did I botch my test?

Apparently I did. I retested this patch using next-20140925. Now the
generated .config before and after applying this patch are identical. So
all's good: this select really is a nop.


Paul Bolle

