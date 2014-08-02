Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaHBIVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 04:21:51 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33361 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751189AbaHBIVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 04:21:49 -0400
Date: Sat, 2 Aug 2014 09:21:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 01/11] ARM: brcmstb: add infrastructure for
	ARM-based Broadcom STB SoCs
Message-ID: <20140802082141.GX30282@n2100.arm.linux.org.uk>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com> <1405976886-27807-2-git-send-email-computersforpeace@gmail.com> <CAL_Jsq+Nbk7m9KXhG+Chdpvurp75RrvhFR2oE_LGxV444GSe9Q@mail.gmail.com> <20140731022320.GM3711@ld-irv-0074> <CAL_Jsq+47YtqWwOkxYDzaEOG-+oouvpXvmGaX+Wh3wQ+BNAx_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+47YtqWwOkxYDzaEOG-+oouvpXvmGaX+Wh3wQ+BNAx_w@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 09:33:44AM -0500, Rob Herring wrote:
> On Wed, Jul 30, 2014 at 9:23 PM, Brian Norris
> <computersforpeace@gmail.com> wrote:
> > Like what?
> 
> Errata work-arounds, performance bits, etc. I don't recall exactly
> which ones are per core vs. global. I assume this is an A9, but cores
> with virt extensions would also need to drop to non-secure mode.

The kernel's bringup just before enabling the CPU deals with that stuff
provided your CPU is running in secure mode, but you are right - we /do/
want to encourage platforms to do the errata fixups before they call the
kernel via any entry point.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
