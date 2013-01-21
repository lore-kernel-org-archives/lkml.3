Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3AUUhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:37:24 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:39672 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab3AUUhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:37:23 -0500
X-Auth-Info: +eOZPfnNHh5vyb7a1eFQd3v8c2akLT+6LD+YIufpLHk=
Message-ID: <50FDB509.9030004@denx.de>
Date: Mon, 21 Jan 2013 22:37:13 +0100
From: Heiko Schocher <hs@denx.de>
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 11/15] mtd: davinci_nand: fix OF support
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-12-git-send-email-arnd@arndb.de>
In-Reply-To: <1358788568-11137-12-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On 21.01.2013 18:16, Arnd Bergmann wrote:
> The patch cdeadd "mtd: nand: davinci: add OF support for
> davinci nand controller" ironically causes a build error
> when CONFIG_OF is enabled because of a missing ';'
> character:
> 
> drivers/mtd/nand/davinci_nand.c:527:1: error: expected ',' or ';' before 'extern'
> 
> This is the obvious fix.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Heiko Schocher <hs@denx.de>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Cc: David Woodhouse <David.Woodhouse@intel.com>
> ---
>  drivers/mtd/nand/davinci_nand.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Already fixed here:
http://lists.infradead.org/pipermail/linux-mtd/2013-January/045366.html

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

