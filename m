Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaBJBUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:20:19 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:54086 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbaBJBUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:20:17 -0500
Message-ID: <1391995215.14955.10.camel@x220>
Subject: Re: [PATCH] ARM: multiplatform: remove reference to ARCH_MULTI_V4
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Date: Mon, 10 Feb 2014 02:20:15 +0100
In-Reply-To: <201307141034.42868.arnd@arndb.de>
References: <1373746191.1359.37.camel@x61.thuisdomein>
	 <201307141034.42868.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2014 01:20:15.0891 (UTC) FILETIME=[40F76630:01CF25FE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-14 at 10:34 +0200, Arnd Bergmann wrote:
> On Saturday 13 July 2013, Paul Bolle wrote:
> > The Kconfig symbol ARCH_MULTI_V4 was removed in commit 24e860fbfd
> > ("ARM: multiplatform: always pick one CPU type"). Remove the last
> > reference to it too.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > 0) Untested.
> > 
> > 1) Commit 24e860fbfd is silent on the reason to drop ARCH_MULTI_V4. And
> > the ARM section of the Kconfig files is rather complicated for people,
> > like me, that aren't familiar with the way the ARM universe is divided
> > in architectures, machines, platforms, etc. That makes it hard to say
> > whether ARCH_MULTI_V4 was dropped on purpose or by accident.
> 
> It was dropped on purpose because it is unused in 3.11 but it will
> be used again in 3.12, so I wouldn't bother with your patch.
> 
> Thanks anyway for looking into unused symbols, I think checking for
> unused code like this is very useful in general.

We're now at v3.14-rc1 and ARCH_MULTI_V4 is still unused. Are there still plans to
use it again?


Paul Bolle

