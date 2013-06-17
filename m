Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3FQO6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:58:17 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:63167 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3FQO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:58:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130617143021.GI2718@n2100.arm.linux.org.uk>
References: <1371476360-8751-1-git-send-email-jonas.jensen@gmail.com>
	<5020304.hteFFmWh1u@wuerfel>
	<20130617143021.GI2718@n2100.arm.linux.org.uk>
Date: Mon, 17 Jun 2013 16:58:14 +0200
Message-ID: <CACmBeS3_aqf42sCKeO9TNJSkOPYwvyAXOvYKjrU8_jV6yAKQ-g@mail.gmail.com>
Subject: Re: [PATCH] ARM: mm: cpu_fa526_do_idle: remove WFI
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ulli.kroll@googlemail.com,
        arm@kernel.org, Florian Fainelli <florian@openwrt.org>,
        Imre Kaloz <kaloz@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 June 2013 16:30, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> It replaces the WFI and return with a pure nop, so we will fall through
> to cpu_fa526_dcache_clean_area().  Do we really want to clean a random
> D cache entry depending on what r0 happened to hold at this point?  I
> think not...

I'm sorry for making the assumption that I know even the most basic
ARM assembler...

This is not the sort of thing I deal with (and probably shouldn't) on
a daily basis.

Can I make a guess, remove only mcr and replace it with nop?

Best regards,
Jonas
