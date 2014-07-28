Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaG1OJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:09:01 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21915 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750752AbaG1OI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:08:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/i5x6W1bgF6dI/gw0yFulEweHvloHAQbI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7C7CC5B8527
Date: Mon, 28 Jul 2014 10:08:05 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Benoit Masson <yahoo@perenite.com>
Cc: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 2/2] V4 ARM: mvebu: Added dts defintion for Lenovo
 Iomega ix4-300d NAS
Message-ID: <20140728140805.GQ23220@titan.lakedaemon.net>
References: <1406503839-4662-1-git-send-email-yahoo@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406503839-4662-1-git-send-email-yahoo@perenite.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On Sun, Jul 27, 2014 at 04:30:39PM -0700, Benoit Masson wrote:
> The Lenovo Iomega ix4-300d is a 4-Bay sata NAS with dual Gb,
>  USB2.0 & 3.0, powered by a Marvell Armada XP MV78230 dual core CPU.
> 
> http://shop.lenovo.com/us/en/servers/network-storage/lenovoemc/ix4-300d/
> Signed-off-by: Benoit Masson <yahoo@perenite.com>
> ---
>  arch/arm/boot/dts/Makefile                      |   3 +-
>  arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts | 285 ++++++++++++++++++++++++
>  2 files changed, 287 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts

I've applied this to mvebu/dt with a few minor fixups.

  - Insert empty line between URL and S-o-B
  - Removed i2c compatible property
  - Removed trailing whitespace from multi-line comment at end of file

Also, traditionally, the 'V4' goes inside the square brackets, eg

  [ PATCH V4 2/2 ] ...

This is done because 'git am ...' automagically removes everything
between the square brackets and then takes the rest of the subject line
to be the first line of the commit message.

Well done!

You can view the commit here:

  http://git.infradead.org/linux-mvebu.git/commitdiff/40c2da45366171bdc9ad1968489aaae190248383

thx,

Jason.
