Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbaFWMVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:21:21 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50899 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFWMVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:21:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18u1yqsjxxDkaKmBwmP1XiNN3UAI7Iw50M=
X-DKIM: OpenDKIM Filter v2.0.1 titan 48DA7596F5B
Date: Mon, 23 Jun 2014 08:21:00 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: andrew@lunn.ch, gregory.clement@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the mvebu tree with Linus' tree
Message-ID: <20140623122100.GK21711@titan.lakedaemon.net>
References: <20140623105741.70094961@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623105741.70094961@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:57:41AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the mvebu tree got a conflict in
> arch/arm/mach-mvebu/Kconfig between commit 21278aeafbfa ("ARM: use
> menuconfig for sub-arch menus") from Linus' tree and commit
> 55fc83023212 ("ARM: Kirkwood: Add setup file for netxbig LEDs") from
> the mvebu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good.  Thanks Stephen.

thx,

Jason.
