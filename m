Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaEOQvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:51:07 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:36546 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaEOQvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:51:04 -0400
Date: Thu, 15 May 2014 09:50:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] arm64: Support reboot through watchdog subsystem
Message-ID: <20140515165050.GA24903@roeck-us.net>
References: <1399681883-891-1-git-send-email-linux@roeck-us.net>
 <1399681883-891-3-git-send-email-linux@roeck-us.net>
 <53741A5A.7070503@roeck-us.net>
 <20140515090952.GC27594@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515090952.GC27594@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:09:52AM +0100, Will Deacon wrote:
> On Thu, May 15, 2014 at 02:37:30AM +0100, Guenter Roeck wrote:
> > On 05/09/2014 05:31 PM, Guenter Roeck wrote:
> > > The watchdog subsystem provides an API to perform a system reboot.
> > > Use it.
> > >
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > 
> > Any comments / Ack from the arm maintainers ?
> 
> I'm fine with the arm/arm64 changes, but I still reckon the parameters
> should be dropped unless you have a use for them.

Ok, I'll drop the parameters and send a new version.

Guenter
