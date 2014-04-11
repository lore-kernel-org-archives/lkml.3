Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbaDKP6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:58:53 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44836 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbaDKP6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:58:07 -0400
Date: Fri, 11 Apr 2014 23:57:51 +0800
From: Huang Shijie <shijie8@gmail.com>
To: grmoore@altera.com
Cc: ggrahammoore@gmail.com, Marek Vasut <marex@denx.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        linux-mtd@lists.infradead.org, Insop Song <insop.song@gainspeed.com>,
        Alan Tull <atull@altera.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH V2] Add support for flag status register on Micron chips.
Message-ID: <20140411155747.GA1584@localhost.localdomain>
References: <1397228593-17996-1-git-send-email-grmoore@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397228593-17996-1-git-send-email-grmoore@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 10:03:13AM -0500, grmoore@altera.com wrote:
> From: Graham Moore <grmoore@altera.com>
> 
> Some new Micron flash chips require reading the flag
> status register to determine when operations have completed.
> 
> Furthermore, chips with multi-die stacks of the 65nm 256Mb QSPI also
> require reading the status register before reading the flag status register.
> 
> This patch adds support for the flag status register in the n25q512a1 and n25q00
> Micron QSPI flash chips.
> 
> Signed-off-by: Graham Moore <grmoore@altera.com>
> ---
> V2:
> Remove leading underscore in function names.
> Remove type cast in dev_err call and use the proper format
> specifier instead.
> ---
>  drivers/mtd/devices/m25p80.c |   91 ++++++++++++++++++++++++++++++++++++------
please rebase this patch on the latest l2-mtd, branch spinor.

thanks
Huang Shijie
