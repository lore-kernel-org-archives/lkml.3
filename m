Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3FOCDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 22:03:40 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38742 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3FOCDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 22:03:39 -0400
Date: Fri, 14 Jun 2013 19:03:43 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, balbi@ti.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL v3] at91: USBA DT support / drivers update for 3.11 #1
Message-ID: <20130615020343.GB25585@quad.lixom.net>
References: <1370279139-7181-1-git-send-email-nicolas.ferre@atmel.com>
 <1371247364-23213-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371247364-23213-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 12:02:44AM +0200, Nicolas Ferre wrote:
> Arnd, Olof,
> 
> This is a rework of the previous pull-request done by Jean-Christophe
> PLAGNIOL-VILLARD ([GIT PULL] at91: USBA DT support for 3.11).
> It is also the division of my previous pull request (v2) to extract only
> patches related to drivers. The DT patches will be stacked on top of our
> arm-soc/at91/dt branch in an upcoming pull-request.
> You should see that this material is based on the cleanup branch that you
> already have in arm-soc/at91/cleanup.
> 
> This adds the DT support for USBA gadget driver present in the most recent
> AT91 SoCs.
> As agreed with Arnd and Felipe we send these drivers updates via arm-soc.
> 
> Thanks, best regards,
> 
> The following changes since commit b3f442b0eedbc20b5ce3f4a96530588d14901199:
> 
>   ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-drivers

Pulled, thanks. This had conflicts with some code from fixes. The change/remove
ones were easy (cs-gpio vs interrupts), but there was one dealing with pinctrl.
PLease double-check that there wasn't a need to carry over a fix to the
include-file-based version.


-Olof
