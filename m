Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab3JIJYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:24:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38599 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752021Ab3JIJYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:24:15 -0400
Message-ID: <525520BA.3010304@free-electrons.com>
Date: Wed, 09 Oct 2013 11:24:10 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/8] ARM: add initial support for Marvell Berlin SoCs
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1381235073-17134-9-git-send-email-sebastian.hesselbarth@gmail.com> <20131009112058.683739d0@xhacker>
In-Reply-To: <20131009112058.683739d0@xhacker>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jisheng,

[...]

>> +config MACH_MV88DE3100
> Can you please use MACH_BERLIN2? This is what we used internally in latest BSP
>> +	bool "Marvell 88DE3100 (Armada 1500)"
>> +	select ARM_GIC
>> +	select CACHE_L2X0
> The tauros3 and PL310 are different although the programming interface are
> compatible. In PJ4B and Tauros3, the CP15 cache maintenance commands include
> both L1 and L2, memory mapped PA-based maintenance operations in L2 are not needed.
> How to handle this in cache-l2x0.c?

In this case you can do the same things we have done for Aurora when we use
the "aurora-system-cache" compatible string.

[...]

Regards,
Gregory

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
