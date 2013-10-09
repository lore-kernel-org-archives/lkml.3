Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3JINYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:24:11 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12105 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3JINYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:24:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dZ3wo7IcJpm/xGCSkT5NGEayMFF4bZYU=
Date: Wed, 9 Oct 2013 09:23:56 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] ARM: Dove: fix bad properties of the si5351 clkout2
 used by Cubox audio
Message-ID: <20131009132356.GB5402@titan.lakedaemon.net>
References: <20131008202027.6d9f0bd2@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008202027.6d9f0bd2@armhf>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 08:20:27PM +0200, Jean-Francois Moine wrote:
> As defined in the DT, clkout2 is not allowed to change the pll inside
> si5351.
> 
> This patch extends the properties of clkout2 so that it works as the
> external clock of the audio device in the Cubox.
> 
> Also, as the second si5351 clock is not used in the Cubox, its
> definition is removed.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
> v2:
> - remove clkout1 which is not used in the Cubox (Sebastian Hesselbarth)
> ---
>  arch/arm/boot/dts/dove-cubox.dts | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Applied to mvebu/dt with Sebastian's Ack.

thx,

Jason.
