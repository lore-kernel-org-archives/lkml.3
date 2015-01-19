Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbbASLvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:51:01 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:38275 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbASLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:51:00 -0500
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2015 06:51:00 EST
Date: Mon, 19 Jan 2015 11:39:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ARM: mvebu: remove two selects of ARM_ERRATA_753970
Message-ID: <20150119113944.GB26493@n2100.arm.linux.org.uk>
References: <1421659937.9655.16.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421659937.9655.16.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 10:32:17AM +0100, Paul Bolle wrote:
> ARM_ERRATA_753970 was renamed to PL310_ERRATA_753970 in v3.2, through
> commit fa0ce4035d48 ("ARM: 7162/1: errata: tidy up Kconfig options for
> PL310 errata workarounds"). Still, two selects were added in v3.15 that
> used the previous name. So these selects have always been nops.
> 
> It is clear that the intention here was to select PL310_ERRATA_753970.
> But as, apparently, nothing broke for four releases we can assume
> PL310_ERRATA_753970 isn't actually needed. So let's not rename these two
> selects but just drop them instead.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> v4: Do no bother anymore to rename these selects. I've tried to do that
> a few times ever since v3.15-rc1 was released. Last time, v3, was in
> https://lkml.org/lkml/2014/9/12/231 . And since the people who
> intruduced this issue apparently aren't bothered by it, neither should
> I. So just do the safe and easy thing, which is removing these two
> selects, as they are nops now.

It's really for those who introduced these select statements to decide
what they want to do about them - but in principle, I'd agree with you.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
