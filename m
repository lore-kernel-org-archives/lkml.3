Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaJCOLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:11:17 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52542 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751663AbaJCOLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:11:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+z9F86Xs+8qXqnbQd2tvGFXuc+/9yFdm0=
X-DKIM: OpenDKIM Filter v2.0.1 titan 377EB5F4D04
Date: Fri, 3 Oct 2014 10:11:02 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Benoit Masson <benoitm@perenite.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
Message-ID: <20141003141102.GJ3895@titan.lakedaemon.net>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <-7443282711873112734@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <-7443282711873112734@unknownmsgid>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On Sun, Sep 21, 2014 at 04:11:23PM +0200, Benoit Masson wrote:
> > Le 19 sept. 2014 à 22:14, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
> > this is a patch set preparing barebox support for ix4-300d. As usual,
> > I stumbled upon a few nice-to-haves before actually touching ix4-300d
> > dts. As it is a mach-mvebu thing, I just added the related mailing
> > lists instead of each of the DT maintainers.
> >
> > First 5 patches consolidate SoC-specific pinctrl nodes to one common
> > node in armada-xp.dtsi, compatible overwrites for each SoC, and node
> > alias usage for each board. Also, ge{0,1} pinctrl settings are moved
> > to the common node from one board specific node.
> >
> > Last 3 patches then use that ge{0,1} pinctrl settings on ix4-300d which
> > is vital for bootloader init. During exploration of ix4-300d, I also
> > found a i2c eeprom that has not been added to the dts, yet. Finally,
> > there is only one 74hc595 on ix4 mainboard while dts property is set
> > for two.
> >
> > I cannot recall in detail what is on that eeprom, but IIRC it is nothing
> > important. Some reg,addr pairs for some init stuff that should have
> > already been done by stock u-boot. Anyway, adding the node will do no
> > harm.
> >
> > Patches are based on v3.17-rc1 and intended for v3.18 but I am not in
> > a hurry. I only compile tested this, so a formal Tested-by from Benoit
> > for the ix4 and any other Armada XP board would be great.
> 
> I'm not sure what to test since I only receive some patch from the
> series of 8. Should I get all 8 or only those you sent me. I'll be
> able to test during next week.

Did you ever get a chance to test this series?

thx,

Jason.
