Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaEOJKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:10:33 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34975 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaEOJK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:10:28 -0400
Date: Thu, 15 May 2014 10:09:52 +0100
From: Will Deacon <will.deacon@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
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
Message-ID: <20140515090952.GC27594@arm.com>
References: <1399681883-891-1-git-send-email-linux@roeck-us.net>
 <1399681883-891-3-git-send-email-linux@roeck-us.net>
 <53741A5A.7070503@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53741A5A.7070503@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 02:37:30AM +0100, Guenter Roeck wrote:
> On 05/09/2014 05:31 PM, Guenter Roeck wrote:
> > The watchdog subsystem provides an API to perform a system reboot.
> > Use it.
> >
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> Any comments / Ack from the arm maintainers ?

I'm fine with the arm/arm64 changes, but I still reckon the parameters
should be dropped unless you have a use for them.

Will
