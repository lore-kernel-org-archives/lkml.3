Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3BQAt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 19:49:59 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16719 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753394Ab3BQAt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 19:49:58 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182IGGuISWhzUsoRaM2lsy9u7emQcWuhfw=
Date: Sat, 16 Feb 2013 13:52:53 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Roland Stigge <stigge@antcom.de>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 3/3] arm: mvebu: enable gpio expander over i2c on
 Mirabox platform
Message-ID: <20130216185253.GD23237@titan.lakedaemon.net>
References: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com>
 <1358889025-8530-4-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358889025-8530-4-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:10:25PM +0100, Gregory CLEMENT wrote:
> The Globalscale Mirabox platform can be connected to the JTAG/GPIO box
> through the Multi-IO port. The GPIO box use the NXP PCA9505 I/O port
> expansion IC to provide 40-bit parallel input/output GPIOs. This patch
> enable the use of this expander on the Mirabox.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/boot/dts/armada-370-mirabox.dts |   10 ++++++++++
>  1 file changed, 10 insertions(+)

Applied to mvebu/dt_deps with a dependency on gpio/for-next for:

      89f5df0 gpio: pca953x: add support for pca9505
      f5f0b7a gpio: pca953x: make the register access by GPIO bank

thx,

Jason.
