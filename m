Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbaDVQ6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:58:50 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48752 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbaDVQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:58:48 -0400
X-Auth-Info: N+T3Cb6T907QAx+VxqbIooegl/uHfd28unGyRPx/uIs=
From: Marek Vasut <marex@denx.de>
To: Graham Moore <grmoore@altera.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
Date: Tue, 22 Apr 2014 18:55:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: ggrahammoore@gmail.com, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Insop Song <insop.song@gainspeed.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com> <1398175396-7560-2-git-send-email-grmoore@altera.com>
In-Reply-To: <1398175396-7560-2-git-send-email-grmoore@altera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404221855.57247.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2014 at 04:03:16 PM, Graham Moore wrote:
[...]

>  #define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _flags)	\
> @@ -488,6 +534,8 @@ const struct spi_device_id spi_nor_ids[] = {
>  	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, 0) },
>  	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K) },
>  	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K) },
> +	{ "n25q512ax3",  INFO(0x20ba20, 0, 64 * 1024, 1024, USE_FSR) },
> +	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, USE_FSR) },

Are you sure the n25q512a doesn't use FSR ? Do n25q512a{1,8}3 share the same 
IDs?

[...]
Best regards,
Marek Vasut
