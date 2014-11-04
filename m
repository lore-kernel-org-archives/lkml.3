Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaKDWlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:41:31 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38142 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447AbaKDWla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:41:30 -0500
Date: Tue, 4 Nov 2014 23:41:26 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: at91: rm9200 add system timer resources to
 watchdog
Message-ID: <20141104224126.GD22928@piout.net>
References: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com>
 <3170633.12AsIiHlY5@wuerfel>
 <20141031205756.GB11327@piout.net>
 <3833756.aJxOhkuG91@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3833756.aJxOhkuG91@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/2014 at 22:36:55 +0100, Arnd Bergmann wrote :
> On Friday 31 October 2014 21:57:56 Alexandre Belloni wrote:
> > On 31/10/2014 at 21:50:05 +0100, Arnd Bergmann wrote :
> > > On Friday 31 October 2014 21:45:58 Alexandre Belloni wrote:
> > > > To be able to make the watchdog driver independent from the mach/ includes, pass
> > > > the system timer register space as a resource.
> > > > 
> > > > Also, change the name to avoid conflicting with the at91sam9 watchdog driver.
> > > > 
> > > > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > > > 
> > > 
> > > Doing this change as a separate patch breaks bisection because now the device
> > > name no longer matches untile the other patch is applied too.
> > > 
> > 
> > Yeah, I was not sure how important that was as there is no user of the
> > watchdog in the kernel. My thinking was that both patch can then go
> > through different trees.
> > 
> > I can definitely squash them.
> 
> AFAICT, arch/arm/configs/at91rm9200_defconfig enables the device and it
> gets registered through at91_add_standard_devices. You definitely have
> my Ack to merge the mach-at91 patch through the watchdog tree.
> 

You're right, I missed that one. I was expecting it to be called from
board files.

So, I'll squash both patches, add your SoB and your Ack and get it
merged through the watchdog tree, tell me if that is not what you
expect.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
