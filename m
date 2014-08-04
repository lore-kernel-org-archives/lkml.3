Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaHDQ4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:56:34 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53392 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaHDQ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:56:31 -0400
Date: Mon, 4 Aug 2014 09:56:27 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v8 03/11] ARM: brcmstb: add debug UART for earlyprintk
 support
Message-ID: <20140804165627.GT3711@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
 <1405976886-27807-4-git-send-email-computersforpeace@gmail.com>
 <20140802083040.GY30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140802083040.GY30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 09:30:40AM +0100, Russell King wrote:
> On Mon, Jul 21, 2014 at 02:07:58PM -0700, Brian Norris wrote:
> > From: Marc Carino <marc.ceeeee@gmail.com>
> > 
> > Add the UART definitions needed to support earlyprintk on brcmstb machines.
> > 
> > Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> > Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> 
> I noticed that you sent this to the patch system.  I asked Olof last
> night whether he had anything in arm-soc touching Kconfig.debug, and
> he does (a number of other platforms have updated it.)  This means
> that if I apply it to my tree, it may conflict, so I'm reluctant to
> take it.

OK... Matt told me that such patches go through you. So which is it?
Should all Kconfig.debug patches go through the arm-soc route?

Brian
