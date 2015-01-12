Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbbALNG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:06:27 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:50170 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbbALNG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:06:26 -0500
Date: Mon, 12 Jan 2015 14:04:30 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: ARM: mvebu: CONFIG_DEBUG_MVEBU_UART_ALTERNATE
Message-ID: <20150112130430.GC19533@lunn.ch>
References: <1421055236.22660.12.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421055236.22660.12.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:33:56AM +0100, Paul Bolle wrote:
> Maxime,
> 
> Your commit d91125ddf962 ("ARM: mvebu: Rename DEBUG_LL to indicate UART
> index") is included in today's linux-next (ie, next-20150112). So is the
> related commit bd920490047a ("ARM: mvebu: Add UART1 as DEBUG_LL possible
> target"). I noticed because a script I use, spotted a minor issue with
> the first commit.
> 
> See, the first commit renamed DEBUG_MVEBU_UART_ALTERNATE to
> DEBUG_MVEBU_UART0_ALTERNATE (so "0" was added). But there's still a last
> reference to CONFIG_DEBUG_MVEBU_UART_ALTERNATE in a comment in
> arch/arm/boot/dts/armada-xp-axpwifiap.dts. Is a patch to rename that
> last reference queued somewhere? If not, should I submit a trivial patch
> to do that?

Hi Paul

Nothing queued, so please do submit a patch.

Thanks
	Andrew
