Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaGLCMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:12:23 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56138 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaGLCMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:12:21 -0400
Date: Fri, 11 Jul 2014 19:12:17 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Graham Moore <grmoore@altera.com>
Cc: ggrahammoore@gmail.com, David Woodhouse <dwmw2@infradead.org>,
        ZY - marex <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Insop Song <insop.song@gainspeed.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH V4] Add support for flag status register on Micron chips.
Message-ID: <20140712021217.GM7537@ld-irv-0074>
References: <1398785391-10744-1-git-send-email-grmoore@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398785391-10744-1-git-send-email-grmoore@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Graham,

On Tue, Apr 29, 2014 at 10:29:51AM -0500, Graham Moore wrote:
> Some new Micron flash chips require reading the flag
> status register to determine when operations have completed.
> 
> Furthermore, chips with multi-die stacks of the 65nm 256Mb QSPI also
> require reading the status register before reading the flag status register.
> 
> This patch adds support for the flag status register in the n25q512ax3 and n25q00
> Micron QSPI flash chips.
> 
> Signed-off-by: Graham Moore <grmoore@altera.com>
> ---
> V4:
> Do not set nor->wait_till_ready if driver has already set it.
> V3:
> Rebase to l2-mtd spinor branch.
> V2:
> Remove leading underscore in function names.
> Remove type cast in dev_err call and use the proper format
> specifier instead.

Sorry for the delay... pushed to l2-mtd.git. Thanks!

Brian
