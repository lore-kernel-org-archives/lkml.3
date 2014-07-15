Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbaGOMGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:06:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43553 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758633AbaGOMGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:06:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19IU6p4G2gR/n5fkqzz4DTi
Date: Tue, 15 Jul 2014 05:04:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, bcousson@baylibre.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH 0/5] Add gta04 board variants
Message-ID: <20140715120455.GC28715@atomide.com>
References: <1405369228-27197-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405369228-27197-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [140714 13:22]:
> This patch series completes the GTA04 device tree to describe all hardware
> components that are on the different variants of the GTA04 boards.
> 
> Marek Belisko (5):
>   arm: dts: omap3-gta04: Add missing nodes to fully describe gta04 board
>   arm: dts: omap3-gta04: Rename gta04.dts to gta04.dtsi and add a4 model
>   arm: dts: Add gta04a3 model
>   arm: dts: Add gta04+b2 model bindings
>   arm: dts: Add gta04+b3 model bindings

Hmm at least the first patch won't apply:

Hunk #4 FAILED at 143.
Hunk #5 succeeded at 142 with fuzz 2 (offset -26 lines).
Hunk #6 succeeded at 287 (offset -26 lines).
Hunk #7 succeeded at 364 (offset -26 lines).
Hunk #8 succeeded at 433 (offset -26 lines).
Hunk #9 succeeded at 472 (offset -26 lines).
Hunk #10 succeeded at 485 (offset -26 lines).
Hunk #11 succeeded at 556 (offset -26 lines).
Hunk #12 FAILED at 720.
2 out of 12 hunks FAILED -- rejects in file arch/arm/boot/dts/omap3-gta04.dts

Can you please repost against let's say v3.16-rc1? Maybe also
check they apply cleanly against omap-for-v3.17/dt branch that
I just pushed out to:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap omap-for-v3.17/dt

Thanks,

Tony
