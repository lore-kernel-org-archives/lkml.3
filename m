Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaEWVbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:31:20 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53775 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaEWVbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:31:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: DT for 3.16 at91-dt3 #3
Date: Fri, 23 May 2014 23:27:51 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1400775895-31183-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1400775895-31183-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201405232327.52312.arnd@arndb.de>
X-Provags-ID: V02:K0:YR2h7YrK13XVw1MrKbEb8eJD1N4CAvoQtaDSYgBzuNl
 SGV6ZwxjO7f+QwJIXKKA9G0jejlWoQYRO/OE/BhzXpcXFQFcai
 orEpJr+qYTY423XbSQ/eO5m+Gri9CctDKEwLfghsuoQhQyrHSV
 3Hsk9su/BkrSOaGfDwYr7C6eo7zAgY0aKWanlGfBkpkdbJkYVH
 bqwkatn5m3AUJop7ngoAF2TYrdyxwPhPnSAXCLci2DUWzudSl6
 ZJ7v98+2eKSjEbrctxAOEQZKtQPQ8CnyuDra0bgSEU9wo7cvo5
 nCVkoI4Xir16k0fnCzpH/SCUDNYHzKiYB2RvG61zM/M4E9lKtH
 40+zXRClnSJDS97wK+FU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2014, Nicolas Ferre wrote:
> Another AT91 DT pull-request for 3.16. This one is the conversion of two more
> SoC to Common Clock Framework (aka CCF). I identified it as a "DT" pull-request
> but it modifies slightly a couple of files in mach-at91 (use of a configuration
> option).

Four done, four more to go? Nice progress!

> This pull-request depends on:
> - the fixes that I already sent for 3.15 and that are present in the recent
>   3.15-rc6 tag.
> - the at91-cleanup tag that you integrated in your arm-soc/next/soc branch.
> So, as suggested by Arnd on IRC, I merged both of them to act as the base
> before adding the material for this pull-request.
> 
> About the clock nodes that should be grouped in a "clocks" container or not,
> while waiting for a clear statement by the DT maintainers, I kept the clocks
> nodes as they had been written by Boris.
> As proposed by Olof, I plan to send you a comprehensive patch that fixes this
> when Mark gives his point of view.

Ok. I've merged it into next/dt now.

	Arnd
