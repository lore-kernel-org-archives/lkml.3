Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3AWKs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:48:27 -0500
Received: from smtp-out-073.synserver.de ([212.40.185.73]:1442 "EHLO
	smtp-out-073.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3AWKs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:48:26 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11710
Message-ID: <50FFC02C.9000109@metafoo.de>
Date: Wed, 23 Jan 2013 11:49:16 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Add axi-clkgen driver
References: <1357755120-32735-1-git-send-email-lars@metafoo.de> <20130122175552.24671.27893@quantum> <50FFB4D8.5060801@metafoo.de> <20130123102755.GP23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130123102755.GP23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 11:27 AM, Russell King - ARM Linux wrote:
> On Wed, Jan 23, 2013 at 11:00:56AM +0100, Lars-Peter Clausen wrote:
>> I think I read somewhere at some point that ioread{8,16,32} is preferred
>> over write{b,h,l} in new code.
> 
> But... there's *no* point using ioread*() if you don't only use the
> ioremap() interface.
> 
> ioread*() is there to allow PC IO and PC MMIO accesses through one
> accessor depending on the cookie.  ioremap() only ever returns cookies
> for MMIO accesses.

So your point is, if you know that it is MMIO memory only ever use readl and
friends?

- Lars
