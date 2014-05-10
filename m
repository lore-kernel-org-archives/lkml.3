Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaEJAxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 20:53:31 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50420 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797AbaEJAxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 20:53:30 -0400
Date: Fri, 9 May 2014 17:53:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] watchdog: Add reboot API
Message-ID: <20140510005320.GA1319@roeck-us.net>
References: <1399681883-891-1-git-send-email-linux@roeck-us.net>
 <536D74E3.8010609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536D74E3.8010609@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:37:55PM -0700, Randy Dunlap wrote:
> On 05/09/2014 05:31 PM, Guenter Roeck wrote:
> > Some hardware implements reboot through its watchdog hardware, for example
> > by triggering a watchdog timeout or by writing into its watchdog register
> > set. Platform specific code starts to spread into watchdog drivers,
> > typically by setting pointers to a callback function which is then called
> > from the architecture's reset handler.
> 
> No updates to Documentation/watchdog/ ?
> 

You are absolutely right, I missed that completely.
Will follow in v3.

Thanks,
Guenter
