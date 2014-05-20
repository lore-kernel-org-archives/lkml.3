Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaETPtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:49:21 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34196 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaETPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:49:20 -0400
Date: Tue, 20 May 2014 16:48:19 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Bolle <pebolle@tiscali.nl>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
Message-ID: <20140520164819.63357114@alan.etchedpixels.co.uk>
In-Reply-To: <20140517092337.GA67711@MacBook-Pro.local>
References: <1364507176.1345.45.camel@x61.thuisdomein>
	<8309592.drxAj71PnZ@wuerfel>
	<1400059550.31197.12.camel@x220>
	<4305975.PvMXZQ020k@wuerfel>
	<1400232598.20342.16.camel@x220>
	<20140516125545.GO3693@n2100.arm.linux.org.uk>
	<20140517092337.GA67711@MacBook-Pro.local>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> old features. Let's say in 10 years time we remove everything ARMv4,
> another 10 years ARMv5 and so on. We could make these milestones shorter
> but it really depends on what people use, we should not force them out
> of the kernel if still in use.

Why do you care ? Worry about it at the point nobody can remember needing
the support, or when it creates some horrible situation that is painful
to keep supporting and nobody seems to care. We've only recently dropped
80386 support, and we still support MC68000.

Or just wait until 2038 approaches and the 32bit panic stations begins,
then clean out 8)

Alan
