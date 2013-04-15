Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3DOK1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:27:19 -0400
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:51532 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751528Ab3DOK1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:27:18 -0400
Date: Mon, 15 Apr 2013 12:14:04 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-doc@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Lee Jones <lee.jones@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Russ Dill <Russ.Dill@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Matt Porter <mporter@ti.com>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-omap@vger.kernel.org, Matt Ranostay <mranostay@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Joel A Fernandes <agnel.joel@gmail.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
Message-ID: <20130415101404.GA1952@game.jcrosoft.org>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
 <93BF5C62-ADE8-4EFC-9175-C2D7E43300E3@antoniou-consulting.com>
 <20130107210551.GL14149@atomide.com>
 <201301072135.05166.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301072135.05166.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 15275646986166119172
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrudeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.500008/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrudeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:35 Mon 07 Jan     , Arnd Bergmann wrote:
> (Adding Sascha Hauer, Linus Walleij, Lee Jones to Cc)
> 
> On Monday 07 January 2013, Tony Lindgren wrote:
> > > 
> > > At the end of the line, some kind of hardware glue is going to be needed.
> > > 
> > > I just feel that drawing from a sample size of 1 (maybe 2 if I get to throw
> > > in the beagleboard), it is a bit premature to think about making it overly
> > > general, besides the part that are obviously part of the infrastructure 
> > > (like the DT overlay stuff).
> > > 
> > > What I'm getting at, is that we need some user experience about this, before
> > > going away and creating structure out of possible misconception about the uses. 
> > 
> > IMHO stuff like this will be needed by many SoCs. Some examples of similar
> > things for omaps that have eventually become generic frameworks have been
> > the clock framework, USB OTG support, runtime PM, pinmux framework and
> > so on.
> > 
> > So I suggest a minimal generic API from the start as that will make things
> > a lot easier in the long run.
> 
> I agree. The ux500 platform already has the concept of "user interface boards",
> which currently is not well integrated into devicetree. I believe Sascha
> mentioned that Pengutronix had been shipping some other systems with add-on
> boards and generating device tree binaries from source for each combination.
> 
> Ideally, both of the above should be able to use the same DT overlay logic
> as BeagleBone, and I'm sure there are more of those.
I'm looking for this also as on at91 sama9x5ek and sam9cn12ek and the
sama5d3xek, we have 1 wire eeproms to detect the boards (motherboards and
daugther boards)
where we have 1 1-wire per board and cpu boards so we can detect everything
and have it's revision and more information

we already have barebox that detect the 1-wire but we need the same handling
in the kernel

Best Regards,
J.
> 
> 	Arnd
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
