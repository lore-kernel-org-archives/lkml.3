Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbaJaU6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:58:00 -0400
Received: from down.free-electrons.com ([37.187.137.238]:44978 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756424AbaJaU57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:57:59 -0400
Date: Fri, 31 Oct 2014 21:57:56 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: at91: rm9200 add system timer resources to
 watchdog
Message-ID: <20141031205756.GB11327@piout.net>
References: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com>
 <3170633.12AsIiHlY5@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3170633.12AsIiHlY5@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/2014 at 21:50:05 +0100, Arnd Bergmann wrote :
> On Friday 31 October 2014 21:45:58 Alexandre Belloni wrote:
> > To be able to make the watchdog driver independent from the mach/ includes, pass
> > the system timer register space as a resource.
> > 
> > Also, change the name to avoid conflicting with the at91sam9 watchdog driver.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > 
> 
> Doing this change as a separate patch breaks bisection because now the device
> name no longer matches untile the other patch is applied too.
> 

Yeah, I was not sure how important that was as there is no user of the
watchdog in the kernel. My thinking was that both patch can then go
through different trees.

I can definitely squash them.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
