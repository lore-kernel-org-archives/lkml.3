Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3EHXrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:47:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41226 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750830Ab3EHXrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:47:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+rQA/3leNK7urAGwAwlAUH
Date: Wed, 8 May 2013 16:47:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: Vincent =?utf-8?Q?Stehl=C3=A9?= <v-stehle@ti.com>, b-cousson@ti.com,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] ARM:dts:omap4-panda:Update the LED support for the
 panda DTS
Message-ID: <20130508234745.GV32546@atomide.com>
References: <1366229760-4808-1-git-send-email-dmurphy@ti.com>
 <516FBD18.3060501@ti.com>
 <51703BEF.6050804@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51703BEF.6050804@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Murphy <dmurphy@ti.com> [130418 11:35]:
> On 04/18/2013 04:30 AM, Vincent Stehlé wrote:
> >On 04/17/2013 10:16 PM, Dan Murphy wrote:
> >>The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
> >>are different.
> >(..)
> >>diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
> >>index 03bd60d..0c48f6b 100644
> >>--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
> >>+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
> >(..)
> >>@@ -135,6 +136,25 @@
> >>  			0xf0 0x118     /* i2c4_sda PULLUP | INPUTENABLE | MODE0 */
> >>  		>;
> >>  	};
> >>+
> >>+	led_gpio_pins: pinmux_leds_pins {
> >>+		pinctrl-single,pins = <
> >>+		>;
> >>+	};
> >>+};
> >Hi,
> >
> >FYI, there was a recent discussion precisely on this topic, where Tomy
> >suggested to remove the empty section:
> >http://marc.info/?l=linux-omap&m=136546635409232&w=2
> >
> >Apart from that, I just tested your patch on top of Tomy's
> >omap-for-v3.10/dt branch and it is working fine for me on PandaBoards
> >EA3, A4 and ES.
> >
> >Tested-by: Vincent Stehlé <v-stehle@ti.com>
> >
> >Best regards,
> >
> >V.
> >
> Thanks for testing Vincent
> 
> Is there a way to append the data to an already existing node?
> I do not see a clean way.

If you have something in omap4-panda-common.dtsi and the same entry
in the omap4-panda-es.dts, the entries in omap4-panda-es.dts will
override and append the entries in omap4-panda-common.dtsi.

So I think you can avoid the empty entry that way.

Regards,

Tony
