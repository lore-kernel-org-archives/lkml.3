Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3BRAup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 19:50:45 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50150 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab3BRAun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 19:50:43 -0500
Date: Sun, 17 Feb 2013 16:50:49 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Wu, Josh" <Josh.wu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [GIT PULL] at91: more DT changes related to MTD for 3.9
Message-ID: <20130218005049.GD4615@quad.lixom.net>
References: <511B78C5.5030209@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511B78C5.5030209@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 12:28:05PM +0100, Nicolas Ferre wrote:
> Hi Olof, Arnd,
> 
> I would like you to consider this little pull request for modification of some
> AT91 Device Tree files.
> We have had a discussion about this material earlier and now that Artem has queued
> the driver modifications for MTD, I would like to know if it is possible to
> add these two patches in your late/dt branch?

Note that unless you break existing bindings (which you should never, or very
very rarely do), adding the new contents doesn't have to wait for the driver
changes. As long as the bindings are settled, the DT changes can go in.

> The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:
> 
>   Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-dt-late

Pulled, thanks.


-Olof
