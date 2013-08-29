Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab3H2Uco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:32:44 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37776 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab3H2Ucn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:32:43 -0400
Date: Thu, 29 Aug 2013 13:32:04 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org, Josh Wu <josh.wu@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: device tree update for 3.12 #2
Message-ID: <20130829203204.GS18542@quad.lixom.net>
References: <1377510062-14886-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377510062-14886-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 11:41:02AM +0200, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is a second update on the DT front for AT91 on 3.12. This series is
> stacked on top of patches that are already included in your at91/dt branch.
> 
> The inclusion of these Nand Flash Controller properties in DT are related to
> the driver enhancement that is already queued in MTD tree:
> http://git.infradead.org/linux-mtd.git/commit/7dc37de7d59cdd1c4cdd472e1994c31b16d7b874
> 
> Thanks, best regards,
> 
> The following changes since commit 90d01929ad38259596371c78df8a9ecf37a7f815:
> 
>   ARM: at91/dt: sam9x5ek: add sound configuration (2013-08-21 13:33:44 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-dt

Pulled into late/all.


-Olof
